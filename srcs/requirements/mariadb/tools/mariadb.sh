#!/bin/sh

# Vérifier si le répertoire /run/mysqld existe
if [ -d "/run/mysqld" ]; then
    echo "[i] mysqld already present, skipping creation"
    chown -R mysql:mysql /run/mysqld
else
    echo "[i] mysqld not found, creating..."
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
    chmod 755 /run/mysqld
fi

# Vérifier si les fichiers MySQL existent déjà
if [ -d /var/lib/mysql/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] MySQL data directory not found, creating initial DBs"

    chown -R mysql:mysql /var/lib/mysql

    # Initialiser la base de données avec mysqld
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    tfile=$(mktemp)

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};
CREATE USER '${MYSQL_USER_NAME}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DB_NAME}.* TO '${MYSQL_USER_NAME}'@'localhost';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

    # Démarrer mysqld pour exécuter le script d'initialisation
    /usr/bin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

# Démarrer le serveur MariaDB avec les options nécessaires
exec /usr/bin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0 "$@"

