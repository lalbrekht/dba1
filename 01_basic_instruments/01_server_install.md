# Server installation and control

## Homework

1. Compile PostgreSQL server without extensions and install it
2. Create PostgreSQL cluster and start it
3. Make sure that server is up and running
4. Compile and install all extensions from contrib directory
5. Stop server

## 1. Compile PostgreSQL server without extensions and install it

### Manual installation and running

Up container or virtual machine with Ubuntu 18.04 OS. Prepare OS - install required packages, download postgresql sources and extract it:

```bash
apt-get update
apt-get install wget curl git gcc libreadline-dev zlib1g-dev build-essential -y
wget https://ftp.postgresql.org/pub/source/v11.8/postgresql-11.8.tar.gz
tar -xvf postgresql-11.8.tar.gz
```

Configre, compile and install PostgreSQL. If you need to configre PostgreSQL with various flags, you must do it on this step.

```bash
cd postgresql-11.8 #Dir name may various by PostgreSQL version
./configure
make
make install
```

## 2. Create PostgreSQL cluster and start it

Create postgres system user and prepare data directories. I will be using `/var/data/base` for PGDATA

```bash
useradd -m -d /home/postgres -s /bin/bash postgres  
mkdir -p /var/data/base
chown -R postgres:postgres -R /var/data
```

Next add some environment variables to `postgres` user bash profile. Main var is PATH, without it you will have to use absolte path to PostgreSQL binaries.

```bash
export PATH=$PATH:/usr/local/pgsql/bin
export PGDATA=/var/data/base
export PGHOST=<postgresql_listening_ip>
export PGPORT=<postgresql_listening_port>
```

Next step is to initialize database and start postgresql processes. There is severals way, I will be doing it with environments variables that I set in previous step. All commands must be running from `postgres` system user:

```bash
su - postgres
pg_ctl initdb
pg_ctl start
```

If all done right, you will see next lines:

```log
2020-07-17 13:09:09.983 UTC [13350] LOG:  database system is ready to accept connections
 done
server started
```

## 3. Make sure that server is up and running

There is serveal ways to do it. I show how to view PostgreSQL processes using `ps` utility, show listening port by `ss` command and finally we connect to PostgreSQL cluster using psql client tool.

First, let's check is there any `postgres` processes:

```bash
ps --forest aux | grep postgres
postgres 13350  0.0  0.8 169680 16844 pts/0    S    13:09   0:00 /usr/local/pgsql/bin/postgres
postgres 13352  0.0  0.2 169788  5380 ?        Ss   13:09   0:00  \_ postgres: checkpointer
postgres 13353  0.0  0.1 169680  2676 ?        Ss   13:09   0:00  \_ postgres: background writer
postgres 13354  0.0  0.3 169680  7528 ?        Ss   13:09   0:00  \_ postgres: walwriter
postgres 13355  0.0  0.2 170112  5212 ?        Ss   13:09   0:00  \_ postgres: autovacuum launcher
postgres 13356  0.0  0.0  24620  1908 ?        Ss   13:09   0:00  \_ postgres: stats collector
postgres 13357  0.0  0.1 169964  3544 ?        Ss   13:09   0:00  \_ postgres: logical replication launcher
```

Great, seems like PostgreSQL up and running. Let's see listen ports in our system:

```bash
ss -tnl
State               Recv-Q               Send-Q                                Local Address:Port                               Peer Address:Port
LISTEN              0                    128                                       127.0.0.1:5432                                    0.0.0.0:*
```

As we can see, there is one listen port in our OS (in my case it's demo Docker container with Ubuntu 18.04). And this port is 5432 - default PostgreSQL listen port. Address is localhost, it means that Database will not be accesable from remote host.

And finally go and connect to our db via psql client:

```sql
psql -h 127.0.0.1 -p 5432 -U postgres -d postgres
sql (11.8)
Type "help" for help.

postgres=# select pg_is_in_recovery();
 pg_is_in_recovery
-------------------
 f
(1 row)
```

Query `select pg_is_in_recovery();` check if cluster is in recovery state or not. True(t) for recovery, False(f) for not recovery state. As we see our DB can accept connections and run all queries.

## 4. Compile and install all extensions from contrib dir

Extensions is located in contrib dir alongside with PostgreSQL sources that we download in first task. We must compile them using `make` utility and install. All the same as compile and install PostgreSQL. Let's do it:

```bash
make -C /root/postgresql-11.8/contrib/
make -C /root/postgresql-11.8/contrib/ install
```

After that we can check what extensions are available to us from the database

```sql
psql -h 127.0.0.1 -p 5432 -U postgres -d postgres
postgres=# SELECT name,comment FROM pg_available_extensions ORDER BY name;
        name        |                               comment
--------------------+----------------------------------------------------------------------
 adminpack          | administrative functions for PostgreSQL
 amcheck            | functions for verifying relation integrity
...
```

We can install extension to PostgreSQL using `CREATE EXTANSION <extansion_name>` query:

```sql
postgres=# CREATE EXTENSION amcheck;
CREATE EXTENSION
```

## 5. Stop server

It's simple. Just run from `postgres` user:

```bash
pg_ctl stop
```
