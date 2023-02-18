FROM ubuntu

RUN groupadd --gid %{GID_PI} pi
RUN groupadd --gid %{GID_DOCKER} docker
RUN useradd -rm -d /home/pi -s /bin/bash -g pi -G sudo -G docker -u %{UID_PI} pi

RUN apt-get update \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    dnsutils \
    git \
    gpg \
    lsb-release \
    openssh-server \
    python3 \
    python3-pip \
    python3-requests \
    python3-yaml \
    sudo \
    vim \
    && \
    rm -rf /var/lib/apt/lists/* /etc/sshd/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && \
    apt-get update \
    && \
    apt-get install -y \
    docker-ce-cli \
    && \
    rm -rf /var/lib/apt/lists/*
 
RUN service ssh start

RUN cd /usr/local \
    && \
    curl -fsSL https://go.dev/dl/go1.18.linux-arm64.tar.gz | tar xzf - \
    && \
    cd /usr/local/bin \
    && \
    ln -s /usr/local/go/bin/* .

RUN mkdir -p /usr/local/nodejs \
    && \
    cd /usr/local/nodejs \
    && \
    curl -fsSL https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-arm64.tar.xz | tar xJf - --strip-components 1 \
    && \
    cd /usr/local/bin \
    && \
    ln -s /usr/local/nodejs/bin/* .

RUN npm install -g @vue/cli

RUN cd /usr/local/bin \
    && \
    ln -s /usr/local/nodejs/bin/* . || true

RUN npm install -g npm@8.6.0

CMD ["/usr/sbin/sshd","-D"]
