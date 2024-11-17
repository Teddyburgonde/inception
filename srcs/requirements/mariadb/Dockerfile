FROM debian:bullseye

# Installer MariaDB
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copier le script mariadb.sh
COPY tools/mariadb.sh /mariadb.sh

# Rendre le script exécutable
RUN chmod +x /mariadb.sh

# Définir l'utilisateur root pour éviter les problèmes de permissions
USER root

ENTRYPOINT ["/mariadb.sh"]

