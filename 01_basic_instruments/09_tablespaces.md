# PostgreSQL tablespaces

## Questions

- Why when creating a database without the phrase `TABLESPACE` table default space set to `pg_default`?  



- Create new tablespace

Prepare a directory for new tablespace: `mkdir /var/lib/postgresql/demo_t` and create

```sql
CREATE TABLESPACE demo_t LOCATION '/var/lib/postgresql/demo_t';
```

- Set default tablespace in `template1` database to newly created tablespace

```sql
ALTER DATABASE template1 SET TABLESPACE demo_t;
```

- Create new database

```sql
create database dat_tblspace;
```

- Check which tablespace is used by new database by default

```sql
\l+ dat_tblspace
```

- Check a simlink on filesystem in PGDATA to tablespace

```sql
ls -lah $PGDATA/pg_tblspc
```

- Delete this tablespace

```sql
DROP TABLESPACE demo_t;
ERROR:  tablespace "demo_t" is not empty

DROP DATABASE dat_tblspace;
ALTER DATABASE template1 SET TABLESPACE pg_default;
DROP TABLESPACE demo_t;
```
