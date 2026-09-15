.PHONY: install dev dev-docker up down logs build lint test generate migrate seed clean

install:
	npm ci

dev:
	docker compose up -d db
	npm run dev:backend & npm run dev:frontend

dev-docker:
	docker compose --profile dev up db backend-dev frontend-dev

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f

build:
	npm run build
	docker compose build

lint:
	npm run lint

test:
	npm test

generate:
	npm run db:generate

migrate:
	npm run db:migrate

seed:
	npm exec --workspace backend prisma db seed

clean:
	docker compose down -v --remove-orphans
