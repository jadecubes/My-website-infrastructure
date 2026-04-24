# php/

PHP-FPM container image used by the `app` service in `docker-compose.yml`.

| File | Purpose |
|---|---|
| `Dockerfile` | Builds a PHP 8.2-FPM image with the extensions Laravel + Filament + Spatie Media Library need |

## What gets installed

**Base:** `php:8.2-fpm`

**APT packages:** `git`, `curl`, `zip`, `unzip`, `vim`, plus dev headers for the PHP extensions (`libpng-dev`, `libonig-dev`, `libxml2-dev`, `libzip-dev`, `libicu-dev`).

**PHP extensions (via `docker-php-ext-install`):**
`pdo_mysql`, `mbstring`, `exif`, `pcntl`, `bcmath`, `gd`, `zip`, `intl`.

**Composer:** installed to `/usr/local/bin/composer`.

**Workdir:** `/var/www/html` — the backend project is bind-mounted here from the host by `docker-compose.yml`.

**Exposes:** port `9000` (FPM), consumed by the `web` (nginx) container via `fastcgi_pass app:9000`.

## Rebuilding

```bash
# From the infrastructure root:
docker compose build app
docker compose up -d
```

If you add a new PHP extension here, rebuild the image — a plain `docker compose up` will reuse the old layer.
