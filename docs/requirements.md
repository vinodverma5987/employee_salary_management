# Employee Salary Management Requirements

## Goal

Build a web-based salary management system for ACME's HR manager to maintain compensation data for 10,000 employees across multiple countries and answer operational questions about how the organization pays people.

## Users And Jobs

The primary user is an HR manager who needs to find employees quickly, review current compensation, filter by organizational dimensions, understand pay distribution, and make controlled salary updates without working across spreadsheets.

## Scope

The first release supports a single HR-facing workflow:

- Browse, search, sort, and paginate the 10,000-employee salary dataset.
- Filter employees by country, department, level, and employment status.
- View aggregate compensation metrics including payroll total, average salary, median salary, salary range, country breakdown, department breakdown, and level breakdown.
- Open an employee detail view with salary history and core profile information.
- Update an employee's salary with an effective date and reason, while preserving audit-style salary history.
- Seed deterministic sample data for 10,000 employees across multiple countries, departments, currencies, and levels.

## Functional Requirements

- The backend exposes JSON APIs for employee listing, salary summary analytics, salary updates, and filter option metadata.
- The UI provides a dashboard optimized for scanning, comparison, and repeated HR operations.
- Salary amounts are stored in minor units to avoid floating point errors.
- The application supports country-local currencies in display while calculating summaries by currency groups.
- Salary updates create immutable salary-history records rather than overwriting past salary facts.
- Tests cover salary update behavior, filtering, summary calculations, and API response behavior.

## Non-Functional Requirements

- The application should remain responsive with 10,000 seeded employees by using database-level filtering, sorting, pagination, and indexed query fields.
- Tests should be deterministic and fast, using small focused datasets instead of the full seed.
- The implementation should be easy to run locally and suitable for deployment as one Rails application serving a React-built frontend.

## Deliberately Out Of Scope

- Authentication, authorization, and SSO are excluded because the assessment focuses on compensation workflows rather than identity integration. A production system would require role-based access control before handling real salary data.
- Approval workflows, compensation bands, payroll exports, and HRIS integrations are excluded to keep the release coherent and end-to-end within the assignment timeline.
- Exchange-rate normalization is excluded because salary comparisons across currencies require a business-approved rate source and policy. The app reports currency-specific aggregates instead.
- Personally identifiable document storage is excluded to avoid expanding the privacy and compliance surface area.

## Reasoning

The design favors a compact but complete HR workflow over broad feature sprawl. The core risks in salary software are correctness, auditability, and performance at realistic employee counts, so this release emphasizes reliable salary history, queryable compensation data, and useful analytics over peripheral enterprise integrations.
