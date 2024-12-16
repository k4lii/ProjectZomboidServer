FROM ubuntu:focal

ENV WORK_DIR=/app
ENV PZ_DIR="$WORK_DIR/pz-server"
ENV PZ_LOG_DIR="$PZ_DIR/logs"
ENV SteamAppId=380870
ENV USER=zomboid
ENV USER_UID=1001
ENV GROUP_GID=1002

USER root

RUN groupadd -g $GROUP_GID $GROUP && \
    useradd -u $USER_UID -g $GROUP_GID -d /home/$USER -m -s /bin/bash $USER

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
        wget \
        unzip \
        gosu \
        lib32gcc-s1 \
        lib32stdc++6 \
        libicu-dev \
        libcurl4-gnutls-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /steamcmd && \
    wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C /steamcmd -xzf -

WORKDIR $WORK_DIR

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

RUN mkdir -p $PZ_LOG_DIR

RUN mkdir -p /home/$USER/.steam/sdk64 && \
    chown -R $USER:$GROUP /home/$USER/.steam && \
    chmod -R 770 /home/$USER/.steam

EXPOSE 16261/udp
EXPOSE 16262
EXPOSE 8766/udp
EXPOSE 27015/udp

ENTRYPOINT ["./entrypoint.sh"]
