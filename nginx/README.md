# nginx/

Nginx configuration for the local dev container. Mounted into the `web` service from `docker-compose.yml`.

| File | Purpose |
|---|---|
| `default.conf` | Single server block fronting Laravel + the contact endpoint's rate limit |

## What it does

- Serves Laravel's `public/` directory on port 80 and forwards `*.php` to the `app` PHP-FPM container on `app:9000`.
- Declares a `contact` rate-limit zone (5 requests/minute per IP, ~160k IPs of state) and applies it to `POST /api/contact` with a small `burst=3 nodelay` so a user correcting a typo is not instantly blocked. Laravel's `throttle:5,1` middleware is a second layer behind this.
- Sends basic security headers: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`. Hides the nginx version.
- Gzip-compresses text responses (HTML, CSS, JS, JSON, SVG, …) over 1 KB.
- Caches static assets (`jpg|jpeg|png|gif|ico|css|js|woff|woff2`) for 1 year with `Cache-Control: public, immutable`.
- Denies access to dotfiles (except `/.well-known/…`).

## Production TODO

TLS termination is **not** configured — this file is local-dev-only. Before deploying publicly:

1. Add a `listen 443 ssl` block with cert/key paths.
2. Redirect port 80 → 443.
3. Re-enable HSTS (`Strict-Transport-Security`). HSTS on plain HTTP would brick local dev, which is why it is commented out today.
