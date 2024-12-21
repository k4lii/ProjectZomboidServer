docker run -d --name project_zomboid_server \
        -v $(pwd)/config/Zomboid:/home/zomboid/Zomboid:rw \
        -v $(pwd)/config/Steam:/home/zomboid/Steam:rw \
        -v $(pwd)/server_files:/app/pz-server:rw \
        -p 16261:16261/udp \
        -p 16262:16262/udp \
        -p 27015:27015/tcp \
        -e PZ_ADMIN_PASSWORD=rdd9bQX8JfJ \
        -e STEAM_ENABLED=0 \
        --restart always \
        k4liii/pzomboid:latest