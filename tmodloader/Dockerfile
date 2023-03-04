FROM alpine:3.16.3 AS base

RUN apk add --update-cache \
    unzip

# add the bootstrap file
COPY bootstrap.sh /terraria-server/bootstrap.sh

# version
ENV TERRARIA_VERSION=1436
ENV TMODLOADER_VERSION=v2022.09.47.36

ENV TERRARIA_FILE=terraria-server-${TERRARIA_VERSION}.zip
ENV TERRARIA_LINK=https://terraria.org/api/download/pc-dedicated-server/${TERRARIA_FILE}
ENV TMODLOADER_FILE=tModLoader.zip
ENV TMODLOADER_LINK=https://github.com/tModLoader/tModLoader/releases/download/${TMODLOADER_VERSION}/${TMODLOADER_FILE}

ADD $TERRARIA_LINK /$TERRARIA_FILE
ADD $TMODLOADER_LINK /$TMODLOADER_FILE

RUN unzip /$TERRARIA_FILE -d /terraria && \
    unzip /$TMODLOADER_FILE -d /tmodloader && \
    mkdir -p /terraria-server/tmod && \
    mv /tmodloader/* /terraria-server && \
    mv /terraria/$TERRARIA_VERSION/Linux/* /terraria-server/tmod && \
    mv /terraria-server/serverconfig.txt /terraria-server/serverconfig-default.txt && \
    chmod +x /terraria-server/tModLoader.dll && \
    chmod +x /terraria-server/tmod/TerrariaServer && \
    chmod +x /terraria-server/tmod/TerrariaServer.bin.x86_64

FROM mcr.microsoft.com/dotnet/runtime:6.0

# documenting ports
EXPOSE 7777

# env used in the bootstrap
ENV LOGPATH=/terraria-server/logs
ENV WORLDPATH=/root/.local/share/Terraria/tModLoader/Worlds
ENV MODPATH=/root/.local/share/Terraria/tModLoader/Mods
ENV WORLD_FILENAME=""
ENV CONFIGPATH=/config
ENV CONFIG_FILENAME="serverconfig.txt"

VOLUME [ "${WORLDPATH}", "${MODPATH}", "${CONFIGPATH}", "${LOGPATH}" ]

COPY --from=base /terraria-server/ /terraria-server/

# Set working directory to server
WORKDIR /terraria-server

ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]

