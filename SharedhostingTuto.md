# Installation SharedHosting

Télécharger l'ISO de debian sur leur site web :
[debian ISO](https://www.debian.org/distrib/netinst#smallcd)

Lors de l'installation il faut cocher SSH lorsque l'installaleur le demande et décocher desktop environnement

Installer sudo

*su*
*apt-get install sudo*

Ensuite il faut ajouter notre utilsateur "Admin" à sudo avec la commande :

*sudo visudo* 

Il faut par la suite ajouter en dessous de la ligne "root ALL=(ALL:ALL) ALL" ajouter 
la même ligne mais avec votre nom d'utilisateur.


 \
 \
 \
 \
 \
Installer NGINX

*sudo apt-get install nginx*

Installer PHP-FPM

*sudo apt-get install php-fpm*

Installer mariaDB

*sudo apt-get install mariadb-server*

Installer git pour que les utiliseurs puissent directement cloner sur le serveur

*sudo apt-get install git*




## Droits

Dans le dossier racine

*sudo chmod o-rw *

*sudo chmod o-x /etc /boot /dev /media /opt /root /sys /srv /var /mnt*  

*sudo chmod o-rwx /Scripts/*





# Mise en place des utilisateurs
 
## Informations
Chaque utilisateur aura son site qui tourne sur un port  différent du serveur.

L'emplacement du site sera dans le dossier "home" de l'utilisateur.


## Configuration automatique 

Cloner le git suivant dans votre dossier home :

*git clone https://github.com/gabrielrossier/SharedHosting.git*

puis bloquer l'accès au dossier au autres utilisateurs.

*sudo chmod o-rwx /home/"votre username"

*sudo chmod o-rwx /SharedHosting/* *

Il faut lancer le script : 

*cd /Scripts/sharedHosting*

*./CreateUser.sh*

Suivre les instructions

**ATTENTION IL FAUT IMPERATIVEMENT ECRIRE JUSTE LE MOT DE PASSE A CHAQUE FOIS QUE LE SCRIPTS VOUS LE DEMANDE**




## Configuration manuelle
Dans le dossier home de votre utilisateur administrateur, cloner le repos suivant :

*git clone https://github.com/gabrielrossier/SharedHosting.git*


On commence par créer un utilisateur "test" avec la commande :

*sudo useradd -m test*

Changer le mot de passe de l'utilisateur avec :

*sudo passwd test*




### Structure de fichier

On va maintenant créer la structure de fichier dans le dossier home de l'utilisateur test

*sudo mkdir /home/test/www*

*sudo chown test:www-data /home/test*

*sudo chown test:www-data /home/test/www*

*sudo chmod o-rwx /home/test*

*sudo cp /home/MonCompteAdmin/SharedHosting/default.php /home/test/www/index.php*

*sudo chown test:www-data /home/test/www/index.php*

### Base de données

Connectez-vous à la base de données avec la commande :

*sudo mysql*

Ensuite entrez les commandes suivante :

*CREATE DATABASE test;*

*CREATE USER "test" IDENTIFIED BY "1234";*

*USE test;*

*GRANT ALL ON test TO "test"@"%";*


### Configuration NGINX et PHP-FPM

Rendez-vous dans le repos SharedHosting.

Ensuite executez les commandes suivantes :

*cp _type test*

*sed -i -e "s/\\${port}/UnPortDisponible/" -e "s/\\${userName}/test/" test*

*cp www.conf test.conf*

*sed -i -e "s/\\${userName}/test/" test.conf*

*sudo mv test.conf /etc/php/7.3/fpm/pool.d/*

*sudo mv test /etc/nginx/sites-available/test*

*sudo ln -s /etc/nginx/sites-available/test /etc/nginx/sites-enabled/test*

*sudo service php7.3-fpm restart*

*sudo service nginx restart*


Voilà le site est maintenant disponible sur le port choisi.



# Isolation

Il y a deux éléments qui font que l'isolation fonctionne, le premier est le plus simple utilisateur "other" n'ont pas les droit de lecture ni d'écriture sur les dossiers home des autres.

Le deuxième élément est dans la configuration de php fpm (www.conf) il y a une ligne "user" et une autre "group". Ces deux lignes, définisse quel utilisateur va executer les fonctions php. Par défaut le "user" est "www-data" qui est l'utilisateur de NGINX. Le problème si on laisse ça par défaut, c'est que n'importe quel script php aura les accès de www-data donc accès aux autres home. C'est pour cela que l'on change cette valeur par le nom d'utilisateur.