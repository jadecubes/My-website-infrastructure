# Ethostudio Infrastructure

Docker environment for local development of the ethostudio backend.

## Structure

```
ethostudio-infrastructure/   ← this project (Docker config)
ethostudio-backend/          ← Laravel code (mounted into container)
ethostudio-frontend/         ← Next.js (runs separately)
```

## Requirements

- Docker Desktop

## First-time setup

Run this once:

```bash
make setup
```

This will:
1. Build and start containers
2. Bootstrap Laravel inside the container
3. Install Filament + Spatie Media Library
4. Run migrations and seed initial data

When done:
| URL | What |
|---|---|
| `http://localhost:8000/api` | Laravel API |
| `http://localhost:8000/admin` | Filament admin panel |

Admin login: `admin@ethostudio.com` / `password`

## Daily use

```bash
make start       # start containers
make stop        # stop containers
make logs        # view logs
make shell       # open shell inside PHP container
make migrate     # run migrations
make seed        # run seeders
```

## Running artisan commands

```bash
make artisan CMD="make:model Post -m"
make artisan CMD="route:list"
```

## Installing composer packages

```bash
make require PKG="vendor/package-name"
```
