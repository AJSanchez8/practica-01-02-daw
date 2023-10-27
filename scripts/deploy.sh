#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# Actualizamos la lista de repositorios
 apt update
# Actualizamos los paquetes del sistema
# apt upgrade -y

# Importamos archivo .env
source .env

# Borramos instalaciones previas
rm -rf /tmp/practicaLamp

# Clonamos repo
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/practicaLamp

# Movemos codigo fuente de la aplicacion
mv /tmp/practicaLamp/src/* /var/www/html

# Configuramos config.php
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASS/" /var/www/html/config.php

# Configuramos nombre de la base de datos
sed -i "s/lamp_db/$DB_NAME/" /tmp/practicaLamp/db/database.sql 

# Importamos el script SQL de base de datos
mysql -u root < /tmp/practicaLamp/db/database.sql

# Creamos usuario de base de datos y asignamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"