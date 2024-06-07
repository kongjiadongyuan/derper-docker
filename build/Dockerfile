FROM ubuntu:22.04 as derper_build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y socat wget curl
RUN cd /root && wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz && \
    rm go1.22.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN go install tailscale.com/cmd/derper@main

FROM alpine:3.12
ENV HOSTNAME=""
ENV STUN_PORT=""
ENV CF_Token=""
ENV CF_Email=""
ENV EXTRA_OPT_FOR_ACME=""
MAINTAINER "kongjiadongyuan"
COPY --from=derper_build  /root/go/bin/derper /bin/derper
COPY entrypoint.sh /entrypoint.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash openssl socat curl wget && \
    ln -s /bin/bash /usr/bin/bash && \
    chmod +x /entrypoint.sh

RUN curl https://get.acme.sh | sh -s email=derper@test.com --nocron

CMD ["/entrypoint.sh"]