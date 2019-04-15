DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_DEFAULT = $(DOCKER_COMPOSE) -f docker-compose.yml


.PHONY: setup
setup: docker-build

.PHONY: docker-build
docker-build:
	$(DOCKER_COMPOSE_DEFAULT) build

.PHONY: docker-down
docker-down:
	$(DOCKER_COMPOSE_DEFAULT) down

.PHONY: serve
serve: docker-down docker-build
	$(DOCKER_COMPOSE_DEFAULT) up

.PHONY: shell
shell:
	$(DOCKER_COMPOSE_DEFAULT) run --rm web ash

.PHONY: debug
debug: docker-down docker-build
	$(DOCKER_COMPOSE) -f debug-docker-compose.yml up

.PHONY: test
test: docker-down docker-build
	$(DOCKER_COMPOSE_DEFAULT) run --rm web ./bin/run_tests.sh

.PHONY: lint
lint: docker-down docker-build
	$(DOCKER_COMPOSE_DEFAULT) run --rm web rubocop
