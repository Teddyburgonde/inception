<div align="center">
🔴 GUIDE DE SURVIE POUR LE PROJET INCEPTION DE 42 🔴 😎👌🔥
</div>


<br>

**Par où commencer ?** 🤔
<br>
Docker expliqué en 5 minutes =)
<br>
https://www.youtube.com/watch?v=mspEJzb8LC4
<br>
<br>
**Architecture de ton project**
<br>
<br>
Ici strictement aucune improvisation , suivez ce modele et vous aurez aucun soucis. 
<br>

![architecture](https://github.com/user-attachments/assets/eeb74860-8103-4b33-9664-808da86eea7f)


<br>

## **Setup**

Installer une VM avec :

> **⚠️ Important : Pour des raisons de performance, les conteneurs doivent être construits à partir de :**
>
> **🟥 L’avant-dernière version stable d’Alpine**  
> **🟥 L’avant-dernière version stable de Debian**

Moi, j'ai choisi **Debian**.
<br>
<br>


## **Mots-clefs Dockerfile**

FROM Indiquer à Docker sous quel OS doit tourner votre VM. 

RUN Lance une commande

COPY indiquez ou se trouve votre fichier a copier puis la ou vous souhaitez le copier dans votre VM.

EXPOSE Indique a Docker qu'elle port est utiliser par ce docker.

ENTRYPOINT Defini le programme principal que le conteneur executera toujours.

<br>
<br>

## **Etapes**
1. Faire le Dockfile nginx
<br>
Je vous aide pour le premier Dockerfile mais pas les suivants !

```c
FROM debian:bullseye //Utilise l'image Debian Bullseye comme base

// Met à jour les paquets existants et installe nginx, vim et openssl
RUN apt update -y && apt upgrade -y && \ 
    apt install -y nginx vim openssl && \ 
    mkdir -p /etc/nginx/ssl // Crée le dossier pour stocker les certificats SSL

// Génère un certificat SSL auto-signé avec OpenSSL
RUN openssl req -x509 -nodes \ 
    -out /etc/nginx/ssl/inception.crt \ // Chemin du certificat généré
    -keyout /etc/nginx/ssl/inception.key \ // Chemin de la clé privée générée
    -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=tebandam.42.fr/UID=tebandam" // Informations pour le certificat

// Crée les répertoires nécessaires pour le fonctionnement de Nginx et le stockage des fichiers
RUN mkdir -p /var/run/nginx /var/www/html

// Copie le fichier de configuration personnalisé pour Nginx dans le conteneur
COPY conf/nginx.conf /etc/nginx/nginx.conf

// Définit les permissions pour le répertoire des fichiers web
RUN chmod -R 755 /var/www/html && \ // Permet à tous de lire et exécuter les fichiers
    chown -R www-data:www-data /var/www/html // Change le propriétaire pour www-data (utilisateur par défaut de Nginx)

// Définit la commande par défaut pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"] // Exécute Nginx en mode non-démon pour que le conteneur reste actif
```
<br>

Si tu as fini le Dockfile et le fichier de configuration pour nginx
<br>
tu tape : 
docker build -t nginx .
docker images 
docker run -d -p 443:443 --name nginx-container nginx

Si tu atteris sur : <br>
Warning: Potential Security Risk Ahead
<br>
clique sur avanced puis prendre le risk 

<br>
Si tu vois afficher cette page 

![Screenshot from 2024-11-16 11-30-28](https://github.com/user-attachments/assets/cedd2ba3-3b1f-4b51-a56f-0e76a89f986c)

<br>
Felicitations !!! Container nginx est fini ! =)

<br>
2. Fais le dockerfile de mariadb et le fichier de configuration.
<br>
3. Fais le dockerfile de wordpress et le fichier de configuration.

## **Commandes**

Creer une image docker :

```c
docker build -t <choose_name_of_image> .
```

Vérifier  si l'image a bien été créée :

```c
docker images
```

Lancer un conteneur a partir de l'image

```c
docker run -d -p 8080:80 --name mon_conteneur <name_of_image>
Maintenant, si tu accèdes à http://localhost:8080, tu devrais voir la page d'accueil de NGINX !
```

Affiche la liste des conteneurs en cours d'exécution :

```c
docker ps
```
voir les problemes : 

```c
docker logs
```
Supprimer tout les docker

```c
docker rm -f $(docker ps -aq)
```

Supprimer toutes les images

```c
docker rmi -f $(docker images -aq)
```

supprimer 
```c
/home/tebandam/data
sudo rm -rf mysql/* wordpress/*      
```

Lancer le docker compose
```c
 docker compose up --build   
```

Se connecter a un compte wordpress
```c
https://localhost/
https://tebandam.42.fr/wp-login.php
```
<br>
<br>

## Verifier mariadb 

Aller dans le dossier srcs 
<br>
docker run --env-file .env -d --name mariadb mariadb
puis docker ps 
<br>
docker run --env-file .env -d --name mariadb mariadb
puis
<br>
docker logs mariadb

**Verifier le docker compose** 
docker compose up -d

<br>
<br>

## Entrer dans mariadb
Aller dans le dossier mariadb
<br>
docker exec -it mariadb bash
<br>
mysql -u root -p
<br>
SHOW DATABASES;
<br>
USE nameofdata;
<br>
SHOW TABLES;

<br>



# Projet Inception

## Introduction

Le projet **Inception** vise à approfondir vos compétences en virtualisation et containerisation en utilisant **Docker** et **Docker Compose**. Vous allez créer une mini-infrastructure contenant plusieurs services isolés dans des conteneurs Docker.

---

## Structure des étapes

### 1. **Préparation**

1. Installez Docker et Docker Compose sur votre machine virtuelle (VM).
2. Créez un répertoire de projet avec la structure suivante :
   ```
   ./
   |-- Makefile
   |-- srcs/
       |-- docker-compose.yml
       |-- .env
       |-- requirements/
           |-- mariadb/
           |   |-- Dockerfile
           |   |-- conf/
           |-- nginx/
           |   |-- Dockerfile
           |   |-- conf/
           |-- wordpress/
               |-- Dockerfile
               |-- conf/
   ```
3. Configurez un fichier **Makefile** pour automatiser la construction et le déploiement de vos conteneurs.

---

### 2. **Création des Services**

#### a) **NGINX avec TLS**

- Configurez un conteneur Docker pour **NGINX** avec TLS v1.2 ou v1.3.
- Générez un certificat SSL auto-signé ou utilisez des outils comme **Let’s Encrypt**.
- Exposez uniquement le port **443**.

#### b) **MariaDB**

- Créez un conteneur pour la base de données MariaDB.
- Ajoutez deux utilisateurs : un administrateur (le nom d'utilisateur **ne doit pas contenir “admin”**) et un utilisateur standard.
- Configurez un volume pour la persistance des données.

#### c) **WordPress**

- Installez WordPress dans un conteneur avec **php-fpm**.
- Configurez un volume pour les fichiers du site WordPress.
- Connectez WordPress à MariaDB.

#### d) **Réseau Docker**

- Créez un réseau Docker pour permettre la communication entre les conteneurs.
- Configurez les services dans **docker-compose.yml** avec la directive `networks`.

---

### 3. **Configuration des Fichiers**

#### Fichier `.env`

Stockez vos variables d’environnement (par exemple, mots de passe, noms de domaine) dans un fichier `.env` :

```env
DOMAIN_NAME=votrelogin.42.fr
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=rootpassword
```

**Note** : Ne stockez jamais de mots de passe directement dans vos fichiers Dockerfile.

#### Dockerfiles

Créez un **Dockerfile** pour chaque service (NGINX, MariaDB, WordPress) en respectant les bonnes pratiques Docker (pas de `tail -f`, pas de boucles infinies).

#### docker-compose.yml

- Configurez vos services dans **docker-compose.yml**.
- Assurez-vous que les noms des images Docker correspondent à leurs services respectifs.

#### Volumes

- Configurez deux volumes :
  - Un pour les données de MariaDB.
  - Un pour les fichiers WordPress.
- Montez les volumes dans le répertoire `/home/login/data/`.

---

### 4. **Test et Validation**

1. Lancez vos conteneurs avec `docker-compose up`.
2. Testez l’accès au site WordPress via votre domaine (exemple : `votrelogin.42.fr`).
3. Vérifiez que les services redémarrent correctement en cas de crash.
4. Testez la sécurité de vos certificats SSL (outils comme SSL Labs).

---

## Conseils et Bonnes Pratiques

1. **Documentation** :

   - Lisez la documentation Docker et Docker Compose.
   - Apprenez à utiliser des outils comme OpenSSL pour gérer les certificats.

2. **Organisation** :

   - Gardez vos fichiers propres et bien structurés.
   - Documentez vos configurations dans des fichiers `README` individuels pour chaque service.

3. **Sécurité** :

   - Utilisez des variables d’environnement pour toutes les informations sensibles.
   - Configurez correctement les permissions des volumes.

4. **Debugging** :

   - Utilisez `docker logs` pour déboguer vos conteneurs.
   - Testez vos configurations localement avant de les automatiser.

---

---

## Commandes Utiles

- Démarrer tous les conteneurs :

  ```bash
  docker-compose up --build
  ```

- Arrêter les conteneurs :

  ```bash
  docker-compose down
  ```

- Afficher les logs :

  ```bash
  docker logs <container_name>
  ```

- Accéder à un conteneur :

  ```bash
  docker exec -it <container_name> sh
  ```

---

## Conclusion

Ce projet est une excellente introduction à la virtualisation et à l’infrastructure moderne. Respectez les consignes, soyez organisé, et n’hésitez pas à chercher de l’aide dans la documentation ou à poser des questions à vos camarades. Bonne chance ! 🚀



