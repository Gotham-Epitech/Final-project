#!/bin/sh
set -e

echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"

export PGPASSWORD=$POSTGRES_PASSWORD

echo "Waiting for Postgres to become available..."

until pg_isready -h db -p 5432 -U "$POSTGRES_USER"; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "Postgres is up - executing command"

# Run migrations using the release binary
echo "Running database migrations..."
/app/bin/$APP_NAME eval "Elixir.Backend.ReleaseTasks.migrate()"

# Start the application
echo "Starting the application..."
exec /app/bin/$APP_NAME start
