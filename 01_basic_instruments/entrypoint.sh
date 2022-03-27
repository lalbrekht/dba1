#!/bin/bash
set -e

# if [ "$1" = 'postgres' ]; then
#     chown -R postgres "$PGDATA"

#     if [ -z "$(ls -A "$PGDATA")" ]; then
#         gosu postgres initdb
#     fi

#     exec gosu postgres "$@"
# fi
# 
# exec "$@"
export PGDATA=/var/data/base

/usr/local/pgsql/bin/pg_ctl init -D /var/data/base
/usr/local/pgsql/bin/postgres
