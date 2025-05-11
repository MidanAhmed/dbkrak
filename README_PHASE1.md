# 🐙 krakn – Phase 1 Roadmap (CLI-Only MVP)

This document details the **Phase 1** scope of krakn — the CLI-only MVP that bridges production data with test schemas in PostgreSQL.

---

## 🎯 Objective

Phase 1 focuses on building a **cross-platform CLI tool** that:

- Connects to two PostgreSQL databases
- Computes schema differences (test vs prod)
- Generates SQL to bring the target schema up to date
- Syncs prod data into the updated target schema
- Does all of the above safely, with proper validation and logs

---

## 🧱 Core Features

### 1. `krakn diff`

**Purpose**: Show the schema differences between two databases.

#### Usage:

```bash
krakn diff --from postgres://prod_db --to postgres://test_db
```

#### What it should do:

- Connect to both `--from` (source) and `--to` (target) PostgreSQL databases
- Compare:
  - Tables
  - Columns (names, types, nullability, defaults)
  - Indexes and constraints (optional in Phase 1)
- Output a human-readable diff:
  ```text
  + Added column 'email_verified' to 'users'
  - Removed column 'temp_flag' from 'orders'
  ~ Changed type of 'price' in 'products' from integer → decimal(10,2)
  ```

#### Deliverables:

- Schema introspection
- Diffing engine
- Pretty CLI output

---

### 2. `krakn migrate`

**Purpose**: Generate SQL migration to align the target schema with the source.

#### Usage:

```bash
krakn migrate --from postgres://prod_db --to postgres://test_db > migrate.sql
```

#### What it should do:

- Reuse the `diff` logic
- Output valid SQL statements to transform the target schema into the source schema
  ```sql
  ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
  ALTER TABLE products ALTER COLUMN price TYPE DECIMAL(10,2);
  ```
- **Important**: Do not execute the SQL — only generate it

#### Deliverables:

- SQL generation logic
- Optional output to file or stdout

---

### 3. `krakn sync-data`

**Purpose**: Copy data from prod (source) into test (target), assuming the target schema matches.

#### Usage:

```bash
krakn sync-data --from postgres://prod_db --to postgres://test_db
```

#### What it should do:

- Connect to both databases
- For each matching table:
  - Copy data from source to target
  - Handle mismatched or missing columns gracefully
- Optional flags:
  - `--truncate`: clear target tables before insert
  - `--tables=users,orders`: sync only specific tables

#### Deliverables:

- Data transfer engine
- Insert or `COPY` logic with batching
- Logging and basic stats per table

---

### 4. `krakn help`

Shows CLI usage, arguments, and available commands.

```bash
krakn --help
```

---

## 📂 Directory Structure (Phase 1)

```bash
krakn/
├── src/
│   ├── cli.ts              # Commander CLI entrypoint
│   ├── commands/
│   │   ├── diff.ts
│   │   ├── migrate.ts
│   │   └── sync-data.ts
│   ├── db/
│   │   ├── introspect.ts   # Fetch schema info from PostgreSQL
│   │   ├── compare.ts      # Schema diffing logic
│   │   ├── generateSQL.ts  # Generate migration SQL
│   │   └── transfer.ts     # Data sync logic
│   └── utils/
│       └── logger.ts       # CLI logging and pretty output
├── package.json
├── tsconfig.json
├── README.md
└── README_PHASE1.md
```

---

## ✅ Phase 1 Goals Checklist

| Feature                | Status |
| ---------------------- | ------ |
| CLI scaffold           | ☐      |
| Schema diffing         | ☐      |
| Migration SQL output   | ☐      |
| Data syncing engine    | ☐      |
| Basic flags and config | ☐      |
| Cross-platform support | ☐      |

---

## 🚀 What Comes Next (Beyond Phase 1)

Once Phase 1 is complete, krakn will evolve in future phases to include:

- **Config-driven operations** (e.g., YAML or `.kraknrc`)
- **Data masking and transformation plugins**
- **Dry-run and rollback support**
- **Schema versioning snapshots**
- **Web-based or Electron UI** (schema visualizer, sync dashboards)

---

## 🧠 Developer Notes

- Use PostgreSQL’s information schema + catalog tables (`information_schema.*`, `pg_catalog.*`) for introspection.
- Consider using `pg_dump --schema-only` and parsing it only if necessary.
- Ensure all changes are **non-destructive by default** (unless flags like `--force` are used).
- Make logs readable, errors actionable, and edge cases clear.

---
