# Stage 1: Builder
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Copy requirements
COPY app/requirements.txt .

# Install Python dependencies in a virtual environment
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install only runtime system dependencies (netcat for health checks)
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Set PATH to use virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Copy application code
COPY app/ app/

# Copy entrypoint script
COPY docker/entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# Create non-root user for security
RUN useradd -m -u 1000 flaskuser && \
    chown -R flaskuser:flaskuser /app

# Switch to non-root user
USER flaskuser

# Expose Flask port
EXPOSE 5000

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
