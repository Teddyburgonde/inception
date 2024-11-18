FROM debian:bullseye

# Mettre à jour et installer les paquets nécessaires
RUN apt update -y && apt upgrade -y && \
    apt install -y nginx vim openssl && \
    mkdir -p /etc/nginx/ssl

# Générer le certificat SSL auto-signé
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=tebandam.42.fr/UID=tebandam"

# Créer les dossiers nécessaires pour NGINX
RUN mkdir -p /var/run/nginx /var/www/html

# Copier le fichier de configuration NGINX
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Définir les permissions correctes pour le répertoire web
RUN chmod -R 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Démarrer NGINX en mode non-démon
CMD ["nginx", "-g", "daemon off;"]

