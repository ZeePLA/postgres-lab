# Use the official PostgreSQL image from the Docker Hub
FROM postgres:latest

# Add our custom scripts to the image
COPY start.sh /docker-entrypoint-initdb.d/
COPY config.env /etc/postgres/config.env

# Make the start script executable
RUN chmod +x /docker-entrypoint-initdb.d/start.sh

# Expose the default PostgreSQL port
EXPOSE 5432
