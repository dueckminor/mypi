FROM debian

RUN mkdir -p /opt && chmod 777 /opt
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN curl -sL https://iobroker.net/install.sh | bash -

ADD scripts/iobroker_startup.sh iobroker_startup.sh
RUN chmod +x iobroker_startup.sh

RUN tar cf iobroker.tar iobroker

# CMD [ "/opt/iobroker/iobroker", "start" ]