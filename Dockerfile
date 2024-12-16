FROM ubuntu:focal

ENV WORK_DIR=/app
ENV SteamAppId=380870

USER root

# Ajouter l'architecture i386 et installer les dépendances essentielles
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

# Installer SteamCMD manuellement
RUN mkdir -p /steamcmd && \
    wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C /steamcmd -xzf -

# Répertoire de travail
WORKDIR $WORK_DIR

# Copier le script d'entrée
COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Préparer les répertoires nécessaires pour SteamCMD

RUN mkdir -p ~/.steam/sdk64 && \
    chmod -R 770 ~/.steam


# Exposer les ports requis pour Project Zomboid
EXPOSE 16261/udp
EXPOSE 16262
EXPOSE 8766/udp
EXPOSE 27015/udp

# Point d'entrée
ENTRYPOINT ["./entrypoint.sh"]
