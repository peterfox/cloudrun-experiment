#!/bin/bash
[[ -z "$PORT" ]] && export PORT=8080
sed -i "s/80/$PORT/g" /etc/nginx/nginx.conf

exec "$@"
