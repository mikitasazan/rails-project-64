# Коллективный блог

[![CI](https://github.com/mikitasazan/rails-project-64/actions/workflows/ci.yml/badge.svg)](https://github.com/mikitasazan/rails-project-64/actions/workflows/ci.yml)

Учебный проект Хекслета: аналог Habr — коллективный блог с постами по
категориям, комментариями и лайками.

## Демонстрационный проект

Примеры интерфейса готового приложения: [демонстрация](https://files.hexlet.app/a/z5ld9a).

## Стек

- Ruby 4.0, Rails 8.1
- SQLite3 (разработка и тесты), PostgreSQL (продакшен)
- Tailwind CSS, esbuild, Turbo
- Minitest + power_assert, Rubocop, herb-lint
- Sentry (коллектор ошибок, DSN из переменной окружения SENTRY_DSN)

## Использование

```bash
make setup   # зависимости, сборка фронтенда, база данных с сидами
make start   # веб-сервер на http://localhost:3000
```

Проверка качества:

```bash
make test    # тесты minitest
make lint    # rubocop
```
