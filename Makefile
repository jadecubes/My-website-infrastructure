.PHONY: setup start stop restart logs shell migrate seed

# First-time setup: bootstraps Laravel inside the container
setup:
	cp -n .env.example .env || true
	docker compose up -d --build
	@echo "Waiting for containers to be ready..."
	@sleep 5
	@echo "Bootstrapping Laravel..."
	docker compose exec app composer create-project laravel/laravel /tmp/laravel-base
	docker compose exec app cp -rn /tmp/laravel-base/. /var/www/html/
	docker compose exec app rm -rf /tmp/laravel-base
	@echo "Installing packages..."
	docker compose exec app composer require filament/filament:"^3.2" spatie/laravel-medialibrary
	@echo "Configuring Laravel..."
	docker compose exec app cp /var/www/html/.env.example /var/www/html/.env
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan install:api --no-interaction
	@echo "Installing Filament..."
	docker compose exec app php artisan filament:install --panels --no-interaction
	@echo "Running migrations and seeders..."
	docker compose exec app php artisan migrate --seed
	@echo ""
	@echo "Setup complete!"
	@echo "  API:    http://localhost:8000/api"
	@echo "  Admin:  http://localhost:8000/admin"
	@echo "  Login:  admin@ethostudio.com / password"

# Daily use: start containers
start:
	docker compose up -d

# Stop containers
stop:
	docker compose down

# Restart containers
restart:
	docker compose down && docker compose up -d

# View logs
logs:
	docker compose logs -f

# Open a shell inside the PHP container
shell:
	docker compose exec app bash

# Run migrations
migrate:
	docker compose exec app php artisan migrate

# Run seeders
seed:
	docker compose exec app php artisan db:seed

# Shortcut for artisan commands: make artisan CMD="make:model Foo"
artisan:
	docker compose exec app php artisan $(CMD)

# Install a composer package: make require PKG="vendor/package"
require:
	docker compose exec app composer require $(PKG)
