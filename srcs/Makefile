COMPOSE_FILE = docker-compose.yml

all: up

up:
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans
	@docker system prune -f --volumes

re: clean all
