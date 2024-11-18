#!/bin/sh

# Vérifie si le répertoire /run/mysqld existe, sinon le crée avec les bons droits
if [ -d "/run/mysqld" ]; then
    echo "[i] mysqld already present, skipping creation"
    chown -R mysql:mysql /run/mysqld || true
else
    echo "[i] mysqld not found, creating..."
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld || true
    chmod 755 /run/mysqld
fi

# Vérifie si la base de données MySQL est déjà initialisée
if [ -d /var/lib/mysql/mysql ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] Initializing database..."
    chown -R mysql:mysql /var/lib/mysql

    # Initialiser la base de données
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    # Créer un fichier temporaire pour initialiser la base de données
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        echo "Failed to create temp file"
        exit 1
    fi

    # Ajouter les commandes SQL d'initialisation
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Démarrer MariaDB temporairement pour exécuter le script d'initialisation
    echo "[i] Starting temporary MariaDB server..."
    /usr/sbin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

echo "[i] MariaDB setup complete. Starting MariaDB server..."
# Démarrer MariaDB en mode normal
exec /usr/sbin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0
