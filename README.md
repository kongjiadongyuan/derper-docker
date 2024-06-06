# Docker Derper

A docker container that runs tailscale derper server.

# Usage

```bash
cd build
docker build -t derper_image -f Dockerfile .
```

```bash
docker run -d \
    -e CF_Token=your_cloudflare_token \
    -e CF_Email=your_cloudflare_email \
    -e HOSTNAME=your_domain_name \
    -e STUN_PORT=stun_port \
    -p stun_port:stun_port/udp \
    -p https_port:443/tcp \
    derper_image
```

# Explanation

- `CF_Token`: Your cloudflare token
- `CF_Email`: Your cloudflare email
- `HOSTNAME`: Your domain name, which will be used for accessing the derper server
- `STUN_PORT`: The port you want to use for STUN

Derper cannot change the port it listens on for `https`, so you need to map `443` to the port you want to use for `https`.

Although derper can listen on any port for STUN, but it needs to **KNOW** the port it is listening on, so you need to pass the port number with the `STUN_PORT` environment variable. And you need to map the port to the same port on the host.