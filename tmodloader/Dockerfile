FROM alpine:3.15.0 AS base

RUN apk add --update-cache \
    unzip

# add the bootstrap file
COPY bootstrap.sh /terraria-server/bootstrap.sh

ENV DL_LINK=https://github.com/tModLoader/tModLoader/releases/download/v2022.06.96.4/tModLoader.zip
ENV DL_FILE=tModLoader.zip

ADD $DL_LINK /$DL_FILE

RUN unzip /$DL_FILE -d /terraria && \
    mv /terraria/* /terraria-server && \
    mv /terraria-server/serverconfig.txt /terraria-server/serverconfig-default.txt && \
    chmod +x /terraria-server/TerrariaServer.dll && \

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

