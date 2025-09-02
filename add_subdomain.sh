#!/bin/bash

# Скрипт для автоматизированного добавления поддомена в Nginx c автоматическим получением SSL Let's Encrypt

if [[ $# -lt 3 ]]; then
    echo "Использование: $0 <domain> <port> <yes|no для IP фильтрации>"
    exit 1
fi

DOMAIN="$1"
PORT="$2"
USE_IP_RESTRICTION="$3"

CONF="/etc/nginx/sites-available/$DOMAIN.conf"

# Создаём директорию includes, если нет
sudo mkdir -p /etc/nginx/includes

# Шаблон только с HTTP (80), certbot сам добавит HTTPS!
cat > "$CONF" <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
$(if [[ "$USE_IP_RESTRICTION" == "yes" ]]; then
    echo "        include /etc/nginx/includes/allowed_ips.conf;"
else
    echo "        include /etc/nginx/includes/no_ip_restriction.conf;"
fi)
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Включаем сайт
sudo ln -sf "$CONF" /etc/nginx/sites-enabled/

# Проверяем конфиг и перезапускаем Nginx
sudo nginx -t || { echo "Ошибка в конфиге nginx!"; exit 2; }
sudo systemctl reload nginx

# Получаем и настраиваем SSL-сертификат (certbot сам пропишет HTTPS)
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --register-unsafely-without-email

sudo nginx -t && sudo systemctl reload nginx

echo "Поддомен $DOMAIN добавлен и защищён SSL!"
