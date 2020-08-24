# step to download the needed server files with steamcmd
FROM docker.io/cm2network/steamcmd:root AS build

ARG STEAM_LOGIN=anonymous

RUN ./steamcmd.sh \
    +login ${STEAM_LOGIN} \
    +force_install_dir /home/steam/deadmatter-dedicated \
    +app_update 1110990 \
    +quit

# copy the downloaded server files into final image based on ubuntu
FROM docker.io/ubuntu
WORKDIR /app 
RUN useradd -m steam

COPY --chown=steam:steam --from=build /home/steam/deadmatter-dedicated .

VOLUME /app/deadmatter/Saved

EXPOSE 27015/udp 7777/udp
ENTRYPOINT ["bash", "deadmatterServer.sh"]
