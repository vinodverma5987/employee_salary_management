# Architecture Notes

## Shape

The app is a single deployable Rails application with SQLite, JSON API endpoints, and a React dashboard served from the Rails root route.

- `Employee` stores the current searchable employee profile and current salary in minor currency units.
- `SalaryChange` stores immutable salary history entries created whenever salary is updated.
- `EmployeeQuery` centralizes search, filtering, sorting, and pagination inputs.
- `SalarySummary` centralizes aggregate compensation metrics.
- `/api/employees` powers table browsing.
- `/api/employees/:id` powers the detail drawer.
- `/api/employees/:id/salary` updates salary and appends salary history in one database transaction.
- `/api/summary` powers dashboard metrics for the current filter set.
- `/api/options` powers filter controls.

## Trade-Offs

SQLite is intentionally used for assessment simplicity and local deployability. The query boundaries and indexes are compatible with moving to PostgreSQL for production scale.

The UI uses React from CDN scripts to avoid adding a separate JavaScript build pipeline to the assignment. In a production team setting, I would move this to Vite or the Rails jsbundling pipeline with pinned npm dependencies, linting, and component tests.

Authentication and authorization are deliberately excluded from the first release per `docs/requirements.md`, but salary data would require SSO, role-based access control, audit logs, and stricter security headers before production use with real employee data.

## Performance Considerations

The seeded dataset has 10,000 employees. Listing uses database filtering, sorting, offsets, limits, and indexes on the most common filter fields. The summary endpoint intentionally aggregates in Ruby for readability at 10,000 rows; for larger datasets or heavier concurrent use, summary calculations should move to SQL group queries or precomputed reporting tables.

Salary amounts are stored as integer cents to avoid floating point rounding errors. Cross-currency totals are grouped by currency rather than converted using arbitrary exchange rates.
