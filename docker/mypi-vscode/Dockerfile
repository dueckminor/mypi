FROM ubuntu

RUN groupadd --gid %{GID_PI} pi
RUN groupadd --gid %{GID_DOCKER} docker
RUN useradd -rm -d /home/pi -s /bin/bash -g pi -G sudo -G docker -u %{UID_PI} pi

RUN apt update \
&& apt install -y 

RUN apt-get update \
    && \
    apt-get install -y \
    curl \
    git \
    gpg \
    lsb-release \
    python3 \
    python3-pip \
    sudo \
    vim \
    && \
    rm -rf /var/lib/apt/lists/*

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

RUN apt-get update \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server \
    && \
    rm -rf /var/lib/apt/lists/*
 
RUN service ssh start

CMD ["/usr/sbin/sshd","-D"]
