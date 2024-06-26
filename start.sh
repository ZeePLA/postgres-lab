#!/bin/bash
set -e

# Source the config file to get the variables
source /etc/postgres/config.env

# Export the environment variables for PostgreSQL
export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
export POSTGRES_DB=$POSTGRES_DB

# Initialize the PostgreSQL database
/docker-entrypoint.sh postgres &

# Wait for PostgreSQL to start
until pg_isready -h localhost -p $POSTGRES_PORT; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Modify postgresql.conf to listen on all interfaces and specified port
PG_CONF="/var/lib/postgresql/data/postgresql.conf"
PG_HBA="/var/lib/postgresql/data/pg_hba.conf"

sed -i "s/#port = 5432/port = $POSTGRES_PORT/" $PG_CONF
echo "listen_addresses = '*'" >> $PG_CONF

# Modify pg_hba.conf to allow all connections (for development purposes)
echo "host all all 0.0.0.0/0 md5" >> $PG_HBA
echo "host all all ::/0 md5" >> $PG_HBA

# Reload PostgreSQL configuration
pg_ctl -D /var/lib/postgresql/data reload
wait
