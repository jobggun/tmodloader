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

COPY --from=base --chown=${USER}:${USER} /terraria-server/ /terraria-server/

WORKDIR /terraria-server

ENV TML_SAVE_DIRECTORY=/tModLoader
ENV CONFIG_FILENAME=serverconfig.txt
ENV WORLD_FILENAME=
VOLUME [ "${TML_SAVE_DIRECTORY}" ]

ARG PUID=1000
ENV USER=terraria
RUN useradd -u "${PUID}" -m "${USER}"

ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]

EXPOSE 7777

USER ${USER}

