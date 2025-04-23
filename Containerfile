# Use official Node.js LTS image as base
FROM node:18-alpine

# Install system dependencies (n8n requires these)
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    git \
    python3 \
    make \
    g++

# Install n8n globally
RUN npm install -g n8n

# Create a non-root user and switch to it (security best practice)
RUN adduser -D -u 1001 n8nuser
USER n8nuser

# Set n8n configuration folder (optional)
ENV N8N_CONFIG_FILES=/home/n8nuser/.n8n

# Create app directory
WORKDIR /home/n8nuser

# Expose ports (HTTP + Webhook)
EXPOSE 5678 5679

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/rest/health || exit 1

# Start n8n
CMD ["n8n", "start"]
