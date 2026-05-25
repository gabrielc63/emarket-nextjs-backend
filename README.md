# Emarket Rails API

Rails API backend for an Amazon-like marketplace. The API currently exposes users and public read-only products under the `/v1` namespace.

## Features

- Rails 8 API-only application
- PostgreSQL database
- Versioned JSON API under `/v1`
- Product model with status, stock, price, SKU, slug, and validations
- Public product endpoints:
  - `GET /v1/products`
  - `GET /v1/products/:id`
- Jbuilder JSON views
- RSpec model and request specs
- Seed data for demo marketplace products
- TypeScript schema generation for the Next.js frontend

## Setup

Use the project Ruby version:

```bash
bundle install
bin/rails db:create db:migrate db:seed
```

Run the API:

```bash
bin/rails server -p 3002
```

## Tests

```bash
bundle exec rspec
```

Current product specs cover:

- Product validations
- Public product listing
- Active-only product visibility
- Draft product hiding

## API Notes

Product responses are public for browsing. Product create, update, and delete should be added after Devise JWT authentication is implemented so seller actions are protected.

## Screenshots

Planned: add screenshots showing the Next.js homepage and product listing consuming this API.
