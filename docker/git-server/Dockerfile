FROM @ALPINE@

RUN apk add --no-cache openssh git

RUN ssh-keygen -A

WORKDIR /git-server/

RUN mkdir /git-server/keys \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:12345 | chpasswd \
  && mkdir /home/git/.ssh

COPY git-shell-commands /home/git/git-shell-commands
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh

EXPOSE 22

CMD ["sh", "start.sh"]
