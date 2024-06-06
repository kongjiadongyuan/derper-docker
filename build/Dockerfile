FROM ubuntu:22.04
MAINTAINER "kongjiadongyuan"

ENV DEBIAN_FRONTEND=noninteractive

# Install systemd
RUN apt-get update && apt-get install -y socat wget curl

# Install derper
RUN cd /root && wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz && \
    rm go1.22.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN go install tailscale.com/cmd/derper@main
RUN mv /root/go/bin/derper /bin/derper && rm -rf /root/go

# Install acme.sh
RUN curl https://get.acme.sh | sh -s email=derper@test.com --force

ENV HOSTNAME=""
ENV STUN_PORT=""
ENV CF_Token=""
ENV CF_Email=""
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]