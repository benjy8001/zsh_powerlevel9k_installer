DOCKER_COMPOSE  = docker-compose

EXEC_DEBIAN        = $(DOCKER_COMPOSE) exec debian

start: ## Pull and start docker debian
start:
	printf "\033[32m You can go take a coffee while we work for you \033[0m\n"
	$(DOCKER_COMPOSE) pull
	$(DOCKER_COMPOSE) up -d --remove-orphans debian	

stop: ## Stop docker
stop:
	$(DOCKER_COMPOSE) stop

run: ## Run the install script on debian
run: start
	$(EXEC_DEBIAN) ./install_zsh.sh install
	$(EXEC_DEBIAN) ./install_zsh.sh setup

connect: ## Connect to the container of the project
	$(EXEC_DEBIAN)

.PHONY: start stop run connect

##
.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help