#!/bin/sh

echo "Waiting for MySQL at $MYSQL_HOST:$MYSQL_PORT..."

# Wait until MySQL is ready to accept connections
while ! nc -z "$MYSQL_HOST" "$MYSQL_PORT"; do
    echo "MySQL is unavailable - sleeping for 2 seconds"
    sleep 2
done

echo "MySQL is up - initializing database"

# Initialize the database (create table if not exists)
python -c "from app.db.mysql import init_db; init_db()"

echo "Starting Flask application with Gunicorn"

# Start the Flask app using Gunicorn (production WSGI server)
exec gunicorn \
    --bind 0.0.0.0:5000 \
    --workers 2 \
    --log-level info \
    app.app:app
