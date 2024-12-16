#!/bin/bash

chown -R $USER:$GROUP $PZ_DIR
if [ -z "$(ls -A "$PZ_DIR" 2>/dev/null)" ]; then
    echo "Directory is empty. Proceeding with installation..."
    /steamcmd/steamcmd.sh +force_install_dir "$PZ_DIR" \
        +login anonymous \
        +app_update $SteamAppId validate \
        +quit
else
    echo "Directory is not empty. Skipping installation."
fi

cp -rf $PZ_DIR/linux64/steamclient.so /home/$USER/.steam/sdk64/steamclient.so
exec > >(tee -a "$PZ_LOG_DIR/server.log") 2>&1

chmod +x *.sh
exec gosu $USER:$GROUP *.sh -servername "$PZ_SERVER_NAME" -adminpassword "${PZ_ADMIN_PASSWORD:-admin}"
