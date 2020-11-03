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

Lorsque tous les services sont installés il faut configurer nginx pour fonctionner avec le php pour cela il faut éditer :

*/etc/nginx/sites-available/default*

et décommenter :

`
location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        }
`



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

Cloner le git suivant :

*sudo git clone https://github.com/gabrielrossier/SharedHosting.git*

puis bloquer l'accès au dossier au autres utilisateurs.

*sudo chmod o-rwx /SharedHosting/* *

Il faut lancer le script : 

*cd /Scripts/sharedHosting*

*./CreateUser.sh*

Suivre les instructions





## Configuration manuelle
On commence par créer un utilisateur "test" avec la commande :

*sudo useradd -m test*

Ensuite 

mysql -p**** <<< "CREATE DATABASE test; "



