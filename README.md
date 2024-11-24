⚠️ EN CONSTRUCTION , derniere mise a jour dimanche 24 novembre 9h27

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
![Screenshot from 2024-11-24 09-12-33](https://github.com/user-attachments/assets/b255ed98-da71-4837-8276-03b67095d7ae)
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

Si tu as fini le Dockfile pour nginx
tu tape : 
docker build -t nginx .
docker images 
docker run -d =p 443:443 --name nginx-container nginx 

Si tu atteris sur : <br>
Warning: Potential Security Risk Ahead
<br>
clique sur avanced puis prendre le risk 

<br>
Si tu vois afficher cette page 
<br>
![Screenshot from 2024-11-16 11-30-28](https://github.com/user-attachments/assets/cedd2ba3-3b1f-4b51-a56f-0e76a89f986c)

<br>
Felicitations !!! Container nginx est fini ! =)


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

## **Verifier mariadb 

Aller dans le dossier srcs 
docker run --env-file .env -d --name mariadb mariadb
puis docker ps 
docker run --env-file .env -d --name mariadb mariadb
puis
docker logs mariadb

**Verifier le docker compose** 
docker compose up -d





