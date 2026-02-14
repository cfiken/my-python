.PHONY: help build up down restart logs ps exec shell stop clean prune
.PHONY: prod-build prod-up prod-down prod-restart prod-logs prod-ps
.PHONY: test lint typecheck format check install sync

COMPOSE_FILE := compose.yaml
COMPOSE_PROD_FILE := compose.prod.yaml
SERVICE := app

help:
	@echo "Docker commands (dev):"
	@echo "  make build      - build dev image"
	@echo "  make up         - start dev container"
	@echo "  make down       - stop and remove dev container"
	@echo "  make restart    - restart dev container"
	@echo "  make logs       - follow dev logs"
	@echo "  make ps         - show dev status"
	@echo "  make exec       - run a command (CMD=...)"
	@echo "  make shell      - open shell in dev container"
	@echo "  make stop       - stop dev container"
	@echo "  make clean      - remove containers and volumes"
	@echo "  make prune      - remove images, networks, volumes"
	@echo ""
	@echo "Docker commands (production):"
	@echo "  make prod-build   - build production image"
	@echo "  make prod-up      - start production container"
	@echo "  make prod-down    - stop production container"
	@echo "  make prod-restart - restart production container"
	@echo "  make prod-logs    - follow production logs"
	@echo "  make prod-ps      - show production status"
	@echo ""
	@echo "Development commands:"
	@echo "  make install    - install dependencies with uv"
	@echo "  make sync       - sync dependencies with uv"
	@echo "  make test       - run tests with pytest"
	@echo "  make lint       - run format + lint check + typecheck (with auto-fix)"
	@echo "  make typecheck  - run type checker (ty) only"
	@echo "  make format     - run code formatter (ruff) only"
	@echo "  make check      - run all checks (lint + test) - use before push"

# ==========================================
# Docker commands (dev)
# ==========================================

build:
	USER_UID=$$(id -u) USER_GID=$$(id -g) docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

restart:
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) up -d

logs:
	docker compose -f $(COMPOSE_FILE) logs -f --tail=200

ps:
	docker compose -f $(COMPOSE_FILE) ps

exec:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) $(CMD)

shell:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) zsh

stop:
	docker compose -f $(COMPOSE_FILE) stop

clean:
	docker compose -f $(COMPOSE_FILE) down -v

prune:
	docker compose -f $(COMPOSE_FILE) down -v --rmi all

# ==========================================
# Docker commands (production)
# ==========================================

prod-build:
	docker compose -f $(COMPOSE_PROD_FILE) build

prod-up:
	docker compose -f $(COMPOSE_PROD_FILE) up -d --build

prod-down:
	docker compose -f $(COMPOSE_PROD_FILE) down

prod-restart:
	docker compose -f $(COMPOSE_PROD_FILE) down
	docker compose -f $(COMPOSE_PROD_FILE) up -d --build

prod-logs:
	docker compose -f $(COMPOSE_PROD_FILE) logs -f --tail=200

prod-ps:
	docker compose -f $(COMPOSE_PROD_FILE) ps

# ==========================================
# Development commands
# ==========================================

install:
	uv pip install -e ".[dev]"

sync:
	uv sync --all-extras

test:
	uv run pytest

lint:
	uv run ruff format .
	uv run ruff check --fix .
	uv run ty check src/

typecheck:
	uv run ty check src/

format:
	uv run ruff format .

check: lint test
