FROM alpine:3

RUN apk add --no-cache --update openssh-server && \
    rm -rf /var/cache/apk/*

COPY sshd_config /etc/ssh/sshd_config

ARG SSH_PORT
ARG SSH_PUB_KEY

RUN printf "Port %s" "$SSH_PORT" >> /etc/ssh/sshd_config && \
    rm /etc/motd && \
    ssh-keygen -A && \
    addgroup -S ssh-user && \
    adduser -S -G ssh-user -s /bin/sh ssh-user && \
    echo "ssh-user:$(head -c128 /dev/urandom | mkpasswd)" | chpasswd --encrypted && \
    mkdir -p /var/ssh/ssh-user && \
    echo "$SSH_PUB_KEY" > /var/ssh/ssh-user/authorized_keys

EXPOSE $SSH_PORT

CMD ["/usr/sbin/sshd", "-D", "-e"]
