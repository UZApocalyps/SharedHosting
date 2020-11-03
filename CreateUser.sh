$userName
$userPassword
$freePort


echo "User Name: " 
read -r userName

if id "$userName" &>/dev/null; then
    echo 'Error: User already exists'
    exit -1
fi

echo "User Password: "


# Create Linux user
sudo useradd -m $userName
sudo passwd $userName
sudo usermod --shell /bin/bash $userName # useradd sets the shell to /bin/sh by default. /bin/bash is supperior for a terminal experience

sudo mkdir /home/$userName/www
sudo chown $userName:www-data /home/$userName/www 
sudo chown $userName:www-data /home/$userName
sudo chmod o-rx /home/$userName
sudo cp default.php /home/$userName/www/index.php
sudo chown $userName:www-data /home/$userName/www/index.php
touch usedPorts

# Create MariaDB DB
sudo mysql <<< "CREATE DATABASE "$userName";"
sudo mysql <<< "CREATE USER "$userName" IDENTIFIED BY '"$userPassword"';"
sudo mysql <<< "USE "$userName"; GRANT ALL ON "$userName" TO '"$userName"'@'%';"

# Sort usedPorts
sudo sort -t, -k2 -n usedPorts -o usedPorts

# Get first free port
lastPort=59999; # = minPort - 1

while read line; do
   port=$(echo $line | cut -d, -f2); # get 2nd column which contains port

   if [ $((port - lastPort)) -gt 1 ] ; then
        break;
   fi

   lastPort=$port
done < <(sort -t, -k2 -- usedPorts) # get lines sorted on port number

freePort=$((lastPort + 1));

echo "Using port: " $freePort

# Add newly used port to usedPorts
echo "$userName,$freePort" >> usedPorts

# Create Nginx site
cp _type $userName
sed -i -e "s/\${port}/$freePort/" -e "s/\${userName}/$userName/" $userName

cp www.conf $userName.conf
sed -i -e "s/\${userName}/$userName/" $userName.conf
sudo mv $userName.conf /etc/php/7.3/fpm/pool.d/
sudo mv $userName /etc/nginx/sites-available/$userName
sudo ln -s /etc/nginx/sites-available/$userName /etc/nginx/sites-enabled/$userName 

sudo service php7.3-fpm restart

sudo service nginx restart
echo "DONE"


