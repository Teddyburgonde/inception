#!/bin/bash

# Créer le répertoire pour le PID de PHP-FPM
mkdir -p /run/php

# Attendre que MariaDB soit disponible
echo "Waiting for MariaDB to be available..."
for i in {1..60}; do
    if mysqladmin ping -h ${WORDPRESS_DB_HOST} --silent; then
        echo "MariaDB is up."
        break
    else
        echo "MariaDB not available, retrying in 10 seconds..."
        sleep 10
    fi
done

cd /var/www/html

# Supprimer les anciens fichiers WordPress s'ils sont présents
if [ -f wp-config.php ]; then
    echo "Removing existing WordPress files..."
    rm -rf wp-admin wp-content wp-includes wp-config.php
fi

# Télécharger WordPress
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "Downloading WordPress core files..."
wp core download --allow-root

echo "Generating wp-config.php..."
wp config create \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbhost=${WORDPRESS_DB_HOST} \
    --allow-root

echo "Installing WordPress..."
wp core install \
    --url=${WORDPRESS_URL} \
    --title="${TITLE}" \
    --admin_user=${WORDPRESS_ADMIN_USER} \
    --admin_password=${WORDPRESS_ADMIN_PWD} \
    --admin_email=${WORDPRESS_ADMIN_EMAIL} \
    --allow-root

echo "Creating additional WordPress user..."
wp user create ${WORDPRESS_USER} ${WORDPRESS_EMAIL} --role=subscriber --user_pass=${WORDPRESS_PASSWORD} --allow-root

chmod -R 775 wp-content

# Démarrer PHP-FPM
php-fpm7.4 -F

