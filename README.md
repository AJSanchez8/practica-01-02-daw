# Guía para un Script Bash de Configuración de Servidor

Este documento es una guía para comprender y ejecutar un script Bash que configura un servidor web Apache con MySQL y PHP. El script incluye comentarios explicativos y comandos útiles para facilitar la configuración del servidor.

## Contenido del Script par instalar pila LAMP [ENLACE](scripts/install_lamp_.sh)

```bash
#!/bin/bash
# Para mostrar los comandos que se van ejecutando
set -x
# Actualizamos la lista de repositorios
apt update
# Actualizamos los paquetes del sistema
# apt upgrade -y -----------> DESCOMENTAR ESTO PARA EJECUTAR POR PRIMERA VEZ, LA "-Y" ES PARA RESPONDER YES A TODAS LAS PREGUNTAS
# Instalamos el servidor APACHE
sudo apt install apache2 -y
## Instalamos MYSQL SERVER
apt install mysql-server -y
# Instalar PHP 
sudo apt install php libapache2-mod-php php-mysql -y
# Copiamos archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available
# Reiniciamos el servicio Apache
systemctl restart apache2
# Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html
# Cambiamos usuario y propietario de var/www/html
chown -R www-data:www-data /var/www/html
```

## Pasos para Ejecutar el Script

1. Abre una terminal en tu servidor, conectandote con la clave con formato .pem

2. Crea un nuevo archivo, por ejemplo, `install_lamp.sh`, y pega el contenido del script en el archivo.

3. Guarda el archivo.

4. Concede permisos de ejecución al archivo: ```chmod +x configuracion-servidor.sh```

##### El paso final sería ejecutar el comando con sudo ```sudo ./install_lamp_.sh```

##  Desplegar aplicacion sencilla de un repositorio

```bash
#!/bin/bash
# Para mostrar los comandos que se van ejecutando
set -x
# Actualizamos la lista de repositorios
 apt update
# Actualizamos los paquetes del sistema
# apt upgrade -y
# Importamos archivo .env
source .env
# Borramos instalaciones previas para que no den problemas
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
```
__Explicación sencilla:__
1. Al importar el archivo [.env](./scripts/.env), tenemos las variables de configuracion "cargadas".
2. Clonamos el repositorio de la aplicación y lo movemos al directorio /var/www/html
3. Configuramos el archivo config.php para que utilice los datos que tenemos guardados en nuestro archivo de variables, con el comando ```sed -i``` busca una cadena y la cambia
4. Despues importamos el script de sql y le damos los permisos necesarios.

