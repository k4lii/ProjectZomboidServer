FROM ubuntu:focal

ENV WORK_DIR=/app
ENV PZ_DIR="$WORK_DIR/pz-server"
ENV SteamAppId=380870
ENV USER=zomboid
ENV GROUP=zomboidgp
ENV USER_UID=1001
ENV GROUP_GID=1002
ENV PZ_SERVER_NAME=FullTeam
ENV PZ_ADMIN_PASSWORD=rdd9bQX8JfJ

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

COPY ./entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

RUN mkdir -p /home/$USER/.steam/sdk64 && \
    chown -R $USER:$GROUP /home/$USER/.steam && \
    chmod -R 770 /home/$USER/.steam

EXPOSE 16261/udp
EXPOSE 16262/udp
EXPOSE 27015/tcp

ENTRYPOINT ["/tmp/entrypoint.sh"]
