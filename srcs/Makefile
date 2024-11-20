# Variables
COMPOSE_FILE = docker-compose.yml

# Commande par défaut : build et démarrage
all: up

# Construire et démarrer les conteneurs
up:
	@docker compose -f $(COMPOSE_FILE) up --build -d

# Arrêter les conteneurs
down:
	@docker compose -f $(COMPOSE_FILE) down

# Nettoyer les volumes, réseaux, et images inutilisés
clean:
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans
	@docker system prune -f --volumes

# Rebuild complet
re: clean all
