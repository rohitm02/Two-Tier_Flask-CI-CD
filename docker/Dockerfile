FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies (netcat for health checks)
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for Docker layer caching)
COPY app/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ app/

# Copy entrypoint script
COPY docker/entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# Expose Flask port
EXPOSE 5000

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
