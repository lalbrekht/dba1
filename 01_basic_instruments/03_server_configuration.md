# PostgreSQL server configuration

## Homework

1. Get parameters (and their values) that need server restart to apply
2. In postgresql.conf set listen_addresses to '*'
3. Apply this setting and ensure that new value took affect

## 1. Get parameters (and their values) that need server restart to apply

There is two views. `pg_setting` show current instance settings and their values.

```sql
SELECT name,setting,pending_restart FROM pg_settings WHERE pending_restart='t';
```

And `pg_file_settings`. Show uncommented settings if postgresql.conf file and additional info like
is there is need to restart database or not to apply this setting. For example, let's modify
`max_connections` parameter and query it:

```sql
postgres=# SELECT * FROM pg_file_settings WHERE name='max_connections';
           sourcefile           | sourceline | seqno |      name       | setting | applied |            error
--------------------------------+------------+-------+-----------------+---------+---------+------------------------------
 /var/data/base/postgresql.conf |         64 |     2 | max_connections | 101     | f       | setting could not be applied
```

## 2. In postgresql.conf set listen_addresses to '*'

Go to $PGDATA/postgresql.conf, uncomment `listen_addresses` line and set it value to `*`:

```md
listen_addresses = '*'
```

## 3. Apply this setting and ensure that new value took affect

There is many ways to apply new settings:

- `SELECT pg_reload_conf();` from psql
- `pg_ctl reload`
- `kill -HUP` send SIGHUP signal to main process

Go to psql and reload from it:

```sql
psql
postgres@postgres=# SELECT name,setting,pending_restart FROM pg_settings WHERE name='listen_addresses';
       name       |  setting  | pending_restart
------------------+-----------+-----------------
 listen_addresses | localhost | f
(1 row)

Time: 1.960 ms
postgres@postgres=# SELECT pg_reload_conf();
 pg_reload_conf
----------------
 t
(1 row)

Time: 0.939 ms
postgres@postgres=# SELECT name,setting,pending_restart FROM pg_settings WHERE name='listen_addresses';
       name       |  setting  | pending_restart
------------------+-----------+-----------------
 listen_addresses | localhost | t
(1 row)

Time: 1.532 ms
postgres=# SELECT * FROM pg_file_settings LIMIT 3;
           sourcefile           | sourceline | seqno |       name       | setting | applied |            error
--------------------------------+------------+-------+------------------+---------+---------+------------------------------
 /var/data/base/postgresql.conf |         59 |     1 | listen_addresses | *       | f       | setting could not be applied
```

Oops. Look's like we can't modify that setting on the fly. Pending_restart is set to True. So, let's restart our cluster.

```sql
pg_ctl restart
psql
postgres@postgres=# SELECT name,setting,pending_restart FROM pg_settings WHERE name='listen_addresses';
       name       |  setting  | pending_restart
------------------+-----------+-----------------
 listen_addresses |     *     | f
(1 row)
```
