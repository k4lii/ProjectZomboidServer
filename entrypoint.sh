#!/bin/bash

if [ -z "$(ls -A "$PZ_DIR" 2>/dev/null)" ]; then
    echo "Directory is empty. Proceeding with installation..."
    /steamcmd/steamcmd.sh +force_install_dir "$PZ_DIR" \
        +login anonymous \
        +app_update $SteamAppId validate \
        +quit
    mkdir -p $PZ_DIR/logs
else
    echo "Directory is not empty. Skipping installation."
fi

chown -R $USER:$GROUP $PZ_DIR
cp -rf $PZ_DIR/linux64/steamclient.so /home/$USER/.steam/sdk64/steamclient.so
exec > >(tee -a "$$PZ_DIR/logs/server.log") 2>&1

chmod +x *.sh
exec gosu $USER:$GROUP $PZ_DIR/*.sh -servername "$PZ_SERVER_NAME" -adminpassword "${PZ_ADMIN_PASSWORD:-admin}"
