# DarkPAN-Indexer 1.0.1 Release Notes

**Released:** 2026-09-10  
**Author:** Rob Lauer \<rclauer@gmail.com\>

---

## Overview

This patch release focuses on refactoring and code quality
improvements: roles have been reorganised into a proper namespace
hierarchy, Perl version and experimental feature dependencies have
been dropped, and `DarkPAN::Resolver::SQLite` has been significantly
reworked to fetch its database directly from S3 rather than requiring
a local file path.

---

## Breaking Changes

### `DarkPAN::Resolver::SQLite` — Resolver invocation signature changed

The resolver no longer accepts a local database file path as the first
positional argument. The mirror URL alone is now sufficient:

**Before (1.0.0):**
```
cpm install \
  --resolver +DarkPAN::Resolver::SQLite,/path/to/cpan-openbedrock-net.db,https://cpan.openbedrock.net/orepan2 \
  Amazon::API~2.6.0
```

**After (1.0.1):**
```
cpm install \
  --resolver +DarkPAN::Resolver::SQLite,https://cpan.openbedrock.net/orepan2 \
  Amazon::API~2.6.0
```

The resolver now fetches `packages.db.gz` directly from S3 using the
mirror URL, creates a temporary local database, and cleans it up
automatically on destruction.

### Role namespace reorganisation

The top-level `DarkPAN::Role::*` roles have been renamed and moved
into the `DarkPAN::Indexer::Role::*` namespace. Any code composing
these roles directly must be updated:

| Old Name | New Name |
|---|---|
| `DarkPAN::Role::Indexer` | `DarkPAN::Indexer::Role::Indexer` |
| `DarkPAN::Role::Loader` | `DarkPAN::Indexer::Role::Loader` |

### Minimum Perl version requirement removed

The explicit `perl 5.024000` requirement and the `experimental` pragma
dependency have been removed. Code using `signatures` has been
refactored to use conventional `@_` unpacking.

---

## New Features

### `DarkPAN::Indexer::Role::Utils` — New shared utility role

A new role, `DarkPAN::Indexer::Role::Utils`, has been introduced to
provide common utility methods shared across the indexer roles and the
SQLite resolver (e.g. `fetch_packages_version_index`).

### `DarkPAN::Resolver::SQLite` — S3-backed database fetching

The resolver now fetches the packages index database directly from S3 at connection time:

- **`_connect()`** (new): Extracts bucket and prefix from the mirror
  URL, fetches `packages.db.gz` via S3, and opens a local SQLite
  connection.
- **`get_s3()`** (new): Lazily constructs an `Amazon::S3::Lite`
  instance. Respects the `AWS_REGION` environment variable, defaulting
  to `us-east-1`.
- **`DESTROY()`** (new): Disconnects the database handle and removes
  the temporary database file on object destruction.

### `DarkPAN::Indexer::Role::Loader` — `load_database` and `update_database` improvements

- `load_database` now accepts an `s3` argument and passes it through
  to `update_database`.
- Database backup is now only created when the `create` flag is set
  (previously it was always attempted when a database file existed).
- `update_database` now accepts and uses an `s3` argument.
- A spurious argument in the `do` statement within `update_database`
  has been removed.

---

## Dependency Changes

| Dependency | Change |
|---|---|
| `experimental` | **Removed** |
| `perl 5.024000` | **Removed** |

All other dependencies remain unchanged. See `cpanfile` for the full current list.

---

## Files Changed

| File | Change |
|---|---|
| `VERSION` | Bumped to `1.0.1` |
| `cpanfile` | Removed `experimental` and `perl` version requirements |
| `requires` | Removed `experimental` and `perl` version requirements |
| `deps.mk` | Regenerated to reflect new role namespaces and `SQLite.pm` dependency on `Role::Utils` |
| `lib/DarkPAN/Indexer.pm.in` | Updated `with` declarations to use renamed roles |
| `lib/DarkPAN/Indexer/Role/Indexer.pm.in` | Renamed from `lib/DarkPAN/Role/Indexer.pm.in` |
| `lib/DarkPAN/Indexer/Role/Loader.pm.in` | Renamed from `lib/DarkPAN/Role/Loader.pm.in`; `load_database` and `update_database` updated |
| `lib/DarkPAN/Indexer/Role/Utils.pm.in` | **New** shared utility role |
| `lib/DarkPAN/Resolver/SQLite.pm.in` | Major refactor — S3-backed DB fetching, removed `experimental`/`signatures`, new `_connect`, `get_s3`, `DESTROY` methods |
| `lib/DarkPAN/Role/Indexer.pm.in` | **Deleted** (replaced by `DarkPAN::Indexer::Role::Indexer`) |
| `lib/DarkPAN/Role/Loader.pm.in` | **Deleted** (replaced by `DarkPAN::Indexer::Role::Loader`) |
