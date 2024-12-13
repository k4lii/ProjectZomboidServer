FROM ubuntu:focal

# Variables d'environnement
ENV GROUP=projectzomboid_group
ENV USER=lorris
ENV USER_UID=1001
ENV GROUP_GID=1002
ENV WORK_DIR=/app
ENV SteamAppId=380870

# Création d'un groupe et d'un utilisateur
RUN groupadd -g $GROUP_GID $GROUP && \
    useradd -u $USER_UID -g $GROUP_GID -d /home/$USER -m -s /bin/bash $USER

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
RUN mkdir -p /home/$USER/.steam/sdk64 && \
    chown -R $USER:$GROUP /home/$USER/.steam && \
    chmod -R 770 /home/$USER/.steam


# Exposer les ports requis pour Project Zomboid
EXPOSE 16261/udp
EXPOSE 16262
EXPOSE 8766/udp
EXPOSE 27015/udp

# Basculer vers l'utilisateur créé
USER root

# Point d'entrée
ENTRYPOINT ["./entrypoint.sh"]
