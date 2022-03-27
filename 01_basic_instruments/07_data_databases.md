
## Practice

- Create new database and connect to it:

```sql
CREATE DATABASE demo;
\c demo
```

- Check new database size:

```sql
/l+ demo
-- OR
SELECT t1.datname AS db_name,  
       pg_size_pretty(pg_database_size(t1.datname)) as db_size
FROM pg_database t1
WHERE t1.datname = 'demo'
ORDER BY pg_database_size(t1.datname) DESC;
-- OR!
SELECT pg_size_pretty(pg_database_size('demo'));
```

- Create two schemas: `app` and `postgres`:

```sql
CREATE SCHEMA app;
CREATE SCHEMA postgres;
```


- Create couple of tables in both schemas and load some data into them:

```sql
-- in schema app
CREATE TABLE app.workers (
  name text,
  surname text
);

INSERT INTO app.workers (name,surname)
  VALUES
  ('Ivan','Ivanov'),
  ('Petr','Petrov'),
  ('Denis','Denisov')
returning *;

CREATE TABLE app.jobs (
  id serial PRIMARY KEY,
  job_name text
);

INSERT INTO app.jobs (job_name)
  VALUES ('DevOps'),('DBA'),('DBA team lead')
returning *;


-- in schema postgres
CREATE TABLE postgres.backup (
  backup_id text,
  backup_size int
);

INSERT INTO postgres.backup (backup_id, backup_size)
  VALUES
  ('OHUAD1','5000'),
  ('OHUAD2','5500'),
  ('OHUAD3','8000')
returning *;
```

- Check how database size is increased:

```sql
/l+ demo
-- OR
SELECT t1.datname AS db_name,  
       pg_size_pretty(pg_database_size(t1.datname)) as db_size
FROM pg_database t1
WHERE t1.datname = 'demo'
ORDER BY pg_database_size(t1.datname) DESC;
```

- Set the search path so that when you connect to the database tables from both schemas were available via unqualified name; should have priority "custom" schema.

```sql
SHOW search_path;
ALTER DATABASE demo SET search_path = "$user",app,postgres;
SHOW search_path;
```
