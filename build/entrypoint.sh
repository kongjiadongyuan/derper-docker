#!/bin/bash

# Check if the environment variables are set
if [ $HOSTNAME == "" ]; then
    echo "HOSTNAME is not set"
    exit 1
fi

if [ $CF_Token == "" ]; then
    echo "CF_Token is not set"
    exit 1
fi

if [ $CF_Email == "" ]; then
    echo "CF_Email is not set"
    exit 1
fi

if [ $STUN_PORT == "" ]; then
    echo "STUN_PORT is not set"
    exit 1
fi

CERT_PATH="/root/certs"

task1() {
    if [ ! -d "$CERT_PATH" ]; then
        echo "[Certbot] Creating directory $CERT_PATH and generating certificates"
        mkdir -p $CERT_PATH
        /root/.acme.sh/acme.sh --issue --dns dns_cf -d $HOSTNAME $EXTRA_OPT_FOR_ACME
        if [ $? -eq 1 ]; then
            echo "[Certbot] Failed to generate certificates"
            exit 1
        fi

        /root/.acme.sh/acme.sh --install-cert -d $HOSTNAME \
            --key-file /root/certs/$HOSTNAME.key \
            --fullchain-file /root/certs/$HOSTNAME.crt \
            --reloadcmd "pkill -f derper"
    fi

    while true; do
        /root/.acme.sh/acme.sh --renew -d $HOSTNAME
        sleep 86400
    done
}

task2() {

    while [ ! -d "/root/certs" ]; do
        echo "[Derper] Waiting for certificates to be generated"
        sleep 5
    done

    while [ ! -f "/root/certs/$HOSTNAME.key" ]; do
        echo "[Derper] Waiting for certificates to be generated"
        sleep 5
    done

    while [ ! -f "/root/certs/$HOSTNAME.crt" ]; do
        echo "[Derper] Waiting for certificates to be generated"
        sleep 5
    done

    while true; do 
        derper -a "0.0.0.0:443" \
            -c /root/derp.conf \
            -certdir /root/certs \
            -certmode manual \
            -hostname $HOSTNAME \
            -stun-port $STUN_PORT
        echo "[Derper] Derper restarted"
        sleep 1
    done

}

task3() {
    while true; do
        echo "[Killer] Killing derper every 48 hours"
        pkill -f derper
        sleep 172800
    done
}

task1 &
task2 &
task3 &

wait