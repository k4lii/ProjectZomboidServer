#!/bin/bash

# Set variables for directories and files
PZ_DIR="/app/pz-server"
PZ_LOG_DIR="$PZ_DIR/logs"
PZ_SERVER_SCRIPT="$PZ_DIR/start-server.sh"

# Ensure ownership of directories
chown -R $USER:$GROUP $PZ_DIR
chown -R $USER:$GROUP /home/$USER/.steam

# Create log directory if it doesn't exist
mkdir -p $PZ_LOG_DIR
chown -R $USER:$GROUP $PZ_LOG_DIR

# Redirect stdout and stderr to log files
exec > >(tee -a "$PZ_LOG_DIR/server.log") 2>&1

# Make the server script executable
chmod +x $PZ_SERVER_SCRIPT

# Run the server script as the specified user
exec gosu $USER:$GROUP $PZ_SERVER_SCRIPT -servername "${PZ_SERVER_NAME:-MyServer}" -adminpassword "${PZ_ADMIN_PASSWORD:-admin}"