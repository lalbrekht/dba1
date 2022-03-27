# Using psql utility

In this homework we study how to use `psql`

## Homework

1. Start `psql` and check current connection properties
2. Query lines from table `pg_tables`
3. Set `less -XS` for page view and query lines from `pg_tables` again
4. Configure psql that with every command it ouputs time of it's completion.
Make sure that with restart this option is saved.
5. Welcome string by default show database name. Configure welcome string
that it will display additionaly information about user: role@database=#

## 1. Start `psql` and check current connection properties

```sql
psql
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/tmp" at port "5432"
```

## 2. Query lines from table `pg_table`

```sql
postgres=# select * from pg_tables limit 3;
 schemaname |    tablename     | tableowner | tablespace | hasindexes | hasrules | hastriggers | rowsecurity
------------+------------------+------------+------------+------------+----------+-------------+-------------
 pg_catalog | pg_statistic     | postgres   |            | t          | f        | f           | f
 pg_catalog | pg_foreign_table | postgres   |            | t          | f        | f           | f
 pg_catalog | pg_authid        | postgres   | pg_global  | t          | f        | f           | f
(3 rows)
```

## 3. Set `less -XS` for page view and query lines from `pg_tables` again

```sql
psql
postgres=# \setenv PAGER 'less -XS'
postgres=# select * from pg_tables;
```

## 4. Configure psql that with every command it ouputs time of it's completion. Make sure that with restart this option is saved

Add string `\timing` to ~/.psqlrc file. And check if it will work in `psql`;

```sql
psql
postgres=# select * from pg_tables limit 3;
 schemaname |    tablename     | tableowner | tablespace | hasindexes | hasrules | hastriggers | rowsecurity
------------+------------------+------------+------------+------------+----------+-------------+-------------
 pg_catalog | pg_statistic     | postgres   |            | t          | f        | f           | f
 pg_catalog | pg_foreign_table | postgres   |            | t          | f        | f           | f
 pg_catalog | pg_authid        | postgres   | pg_global  | t          | f        | f           | f
(3 rows)

Time: 0.679 ms
```

## 5. Welcome string by default show database name. Configure welcome string that it will display additionaly information about user: 'role@database=#'

Add this lines to ~/.psqlrc file:

```sql
\set PROMPT1 '%n@%/%R%#'
\set PROMPT2 '%n@%/%R%#'
```

Now you welcome prompt will be like that:

```sql
psql
postgres@postgres=#
```
