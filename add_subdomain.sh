#!/bin/bash
# Скрипт для добавления поддомена в Nginx + выдачи SSL Let's Encrypt
# Пример: sudo ./add_subdomain.sh app.example.com 3014 no

DOMAIN=$1
PORT=$2
USE_IP_RESTRICTION=$3

CONF="/etc/nginx/sites-available/$DOMAIN.conf"

mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled /etc/nginx/includes

cat > "$CONF" <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
EOF

if [[ "$USE_IP_RESTRICTION" == "yes" ]]; then
    echo "        include /etc/nginx/includes/allowed_ips.conf;" >> "$CONF"
else
    echo "        include /etc/nginx/includes/no_ip_restriction.conf;" >> "$CONF"
fi

cat >> "$CONF" <<EOF
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

ln -s "$CONF" /etc/nginx/sites-enabled/ 2>/dev/null

nginx -t && systemctl reload nginx

certbot --nginx -d "$DOMAIN" --agree-tos --register-unsafely-without-email --non-interactive

nginx -t && systemctl reload nginx
