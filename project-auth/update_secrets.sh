#!/bin/bash

# --- Configuration ---
# Get the directory where the script itself is located
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Set the path to the .env file in the same directory
ENV_FILE="${SCRIPT_DIR}/.env"

# --- Safety Check ---
# (The rest of the script is the same)
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: File not found at $ENV_FILE"
  echo "Please check the ENV_FILE variable in this script."
  exit 1
fi

echo "Generating new secrets..."

# Generate the three unique secrets
JWT_SECRET=$(openssl rand -hex 32)
SESSION_SECRET=$(openssl rand -hex 32)
REDIS_PASS=$(openssl rand -hex 32)

echo "Updating secrets in ${ENV_FILE}..."

# Use 'sed' to find and replace the lines in the file
# This is safe and will not delete other lines.
sed -i "s|^AUTHELIA_JWT_SECRET=.*|AUTHELIA_JWT_SECRET=${JWT_SECRET}|" "$ENV_FILE"
sed -i "s|^AUTHELIA_SESSION_SECRET=.*|AUTHELIA_SESSION_SECRET=${SESSION_SECRET}|" "$ENV_FILE"
sed -i "s|^REDIS_PASSWORD=.*|REDIS_PASSWORD=${REDIS_PASS}|" "$ENV_FILE"

echo "✅ Secret update complete."
echo "Run 'docker-compose up -d --force-recreate' in this directory to apply them."