#!/usr/bin/env bash

PGDATA=/var/lib/postgresql/data/

{
 mkdir -p $PGDATA
chown postgres $PGDATA
gosu postgres initdb

echo "shared_preload_libraries = 'anon'" >> /var/lib/postgresql/data/postgresql.conf

gosu postgres pg_ctl start

cat | gosu postgres psql
} &> /dev/null

echo '--'
echo '-- Generated by PostgreSQL Anonymizer'
echo "-- date: `date`"
echo '--'
gosu postgres psql -qtA -c 'SELECT anon.dump()'

