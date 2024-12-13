FROM ubuntu:focal

# Variables d'environnement
ENV GROUP=projectzomboid_group
ENV USER=lorris
ENV USER_UID=1001
ENV GROUP_GID=1002
ENV WORK_DIR=/app
ENV SteamAppId=380870
ENV PZ_DEPOT_ID=108603
ENV PZ_MANIFEST_ID=8727747655704663044

# Création d'un groupe et d'un utilisateur
RUN groupadd -g $GROUP_GID $GROUP && \
    useradd -u $USER_UID -g $GROUP_GID -d /home/$USER -m -s /bin/bash $USER

# Ajouter l'architecture i386 et installer les dépendances essentielles
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wget unzip gosu lib32gcc-s1 lib32stdc++6 libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Répertoire de travail
WORKDIR $WORK_DIR

# Copier le script d'entrée
COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Préparer les répertoires nécessaires pour Steam SDK
RUN mkdir -p /home/$USER/.steam/sdk64 && \
    chown -R $USER:$GROUP /home/$USER/.steam && \
    chmod -R 770 /home/$USER/.steam

# Télécharger et installer DepotDownloader
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.5.0/DepotDownloader-linux-x64.zip && \
    unzip DepotDownloader-linux-x64.zip -d $WORK_DIR && \
    chmod +x $WORK_DIR/DepotDownloader

# Utiliser DepotDownloader pour télécharger les fichiers spécifiques de Project Zomboid
RUN ./DepotDownloader \
    -app $SteamAppId \
    -depot $PZ_DEPOT_ID \
    -manifest $PZ_MANIFEST_ID \
    -dir $WORK_DIR/pz-server

# Copier steamclient.so dans le répertoire approprié
RUN cp -rf $WORK_DIR/depots/1006/12778849/linux64/steamclient.so /home/$USER/.steam/sdk64/steamclient.so && \
    chown -R $USER:$GROUP /home/$USER/.steam

# Exposer les ports requis pour Project Zomboid
EXPOSE 16261/udp
EXPOSE 8766/udp
EXPOSE 27015/udp

# # Basculer vers l'utilisateur créé
USER root

# Point d'entrée
ENTRYPOINT ["./entrypoint.sh"]
