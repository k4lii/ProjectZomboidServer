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

# Validate server script existence
if [ ! -f "$PZ_SERVER_SCRIPT" ]; then
    echo "Error: Server script not found at $PZ_SERVER_SCRIPT. Ensure the server is installed correctly."
    exit 1
fi

# Redirect stdout and stderr to log files
exec > >(tee -a "$PZ_LOG_DIR/server.log") 2>&1

# Update server files (optional)
steamcmd +login anonymous +force_install_dir $PZ_DIR +app_update 380870 validate +quit

# Make the server script executable
chmod +x $PZ_SERVER_SCRIPT

# Run the server script as the specified user
exec gosu $USER:$GROUP $PZ_SERVER_SCRIPT \
    -servername "${PZ_SERVER_NAME:-LaZone}" \
    -adminpassword "${PZ_ADMIN_PASSWORD:-admin}" \
    -port "${PZ_SERVER_PORT:-16261}" \
    -steamport1 "${PZ_STEAM_PORT1:-8766}" \
    -steamport2 "${PZ_STEAM_PORT2:-27015}"
