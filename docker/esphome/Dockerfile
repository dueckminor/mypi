FROM esphome/esphome

RUN groupadd --gid 1000 pi && useradd --uid 1000 --gid 1000 -m pi
RUN chown -R pi:pi /piolibs

USER pi