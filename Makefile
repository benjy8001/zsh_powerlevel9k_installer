DOCKER_COMPOSE  = docker-compose

EXEC_DEBIAN        = $(DOCKER_COMPOSE) exec -T debian /entrypoint

start:
	printf "\033[32m You can go take a coffee while we work for you \033[0m\n"
	$(DOCKER_COMPOSE) pull
	$(DOCKER_COMPOSE) up -d --remove-orphans debian	

stop:
	$(DOCKER_COMPOSE) stop

run:
	$(EXEC_DEBIAN) ./install_zsh.sh

connect: ## Connect to the container of the project
	$(EXEC_DEBIAN)

.PHONY: start stop run connect
