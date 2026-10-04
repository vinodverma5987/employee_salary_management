# ACME Employee Salary Management

Web-based salary management software for an HR manager operating compensation data for a 10,000 employee organization.

## Features

- Search, filter, sort, and paginate employees.
- View payroll summary metrics for the active filter set.
- Inspect an employee profile and salary history.
- Update salary with effective date and reason.
- Seed deterministic data for 10,000 employees across countries, departments, levels, statuses, and currencies.

## Tech Stack

- Ruby on Rails 8
- SQLite
- React 18 dashboard served by Rails
- Minitest

## Run Locally

```bash
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open `http://localhost:3000`.

## Test

```bash
bin/rails test
```

## Artifacts

- Requirements: `docs/requirements.md`
- AI usage notes: `docs/ai-usage.md`
- Architecture and trade-offs: `docs/architecture.md`
- Demo script: `docs/demo-script.md`
- Deployment notes: `docs/deployment.md`

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
