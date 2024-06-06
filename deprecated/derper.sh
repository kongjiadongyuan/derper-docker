#!/bin/bash
if [ -d "/root/certs" ]; then
    derper -a "0.0.0.0:443" \
        -c /root/derp.conf \
        -certdir /root/certs \
        -certmode manual \
        -hostname $HOSTNAME \
        -stun-port $STUN_PORT
fi