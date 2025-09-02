# 📄 SETUP.md

## 🛠️ Памятка по установке и обслуживанию nginx-domain-provisioner

### 1. Установка ПО

```bash
    sudo apt-get remove certbot, sudo dnf remove certbot, or sudo yum remove certbot

    sudo apt update
    sudo apt install snapd

    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot

    sudo certbot --nginx

    sudo certbot renew --dry-run
    sudo systemctl restart nginx 
```

### 2. Клонирование проекта и подготовка скрипта

```bash
git clone https://github.com/yourname/nginx-domain-provisioner.git
cd nginx-domain-provisioner
chmod +x add_subdomain.sh
```

### 3. Настройка файлов с IP

```bash
sudo mkdir -p /etc/nginx/includes

# Ограниченный доступ:
sudo nano /etc/nginx/includes/allowed_ips.conf
allow 77.51.44.117;   # JOB
allow 89.188.168.102; # HOME
allow 172.18.0.0/16;  # Docker
deny all;

# Открытый доступ:
sudo touch /etc/nginx/includes/no_ip_restriction.conf
```

### 4. Добавление поддомена

- Публичный:

```bash
sudo ./add_subdomain.sh read.app.tw1.ru 3000 no
```

- С фильтрацией по IP:

```bash
sudo ./add_subdomain.sh play.crm-tg-mini-app.tw1.ru 3037 yes
```

### 5. Добавление DNS-записи

- Для каждого поддомена создайте A-запись, указывающую на ваш VDS.

### 6. Проверка работы

- DNS:

```bash
dig +short app.crm-tg-mini-app.tw1.ru
```

- Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 7. Изменение списка IP

- Измените /etc/nginx/includes/allowed_ips.conf и выполните:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 8. Автоматическое продление сертификатов

- Certbot автоматически продлевает все сертификаты!
- Проверить таймер:

```bash
systemctl list-timers | grep certbot
```

- Ручная проверка продления:

```bash
sudo certbot renew --dry-run
```

### 9. Удаление поддомена

```bash
  sudo rm /etc/nginx/sites-enabled/<domain>.conf
  sudo rm /etc/nginx/sites-available/<domain>.conf
  sudo certbot delete --cert-name <domain>
  sudo systemctl reload nginx
```

### 10. Где искать и править конфиги

- Все сайты: /etc/nginx/sites-available/
- Активные: /etc/nginx/sites-enabled/
- Старый default больше не используется.

### 11. Диагностика

- Логи nginx:

```bash
tail -n 50 /var/log/nginx/error.log
```

- Логи certbot:

```bash
tail -n 50 /var/log/letsencrypt/letsencrypt.log
```

- Проверить конфиг:

```bash
sudo nginx -t
```

### 12. PS

НЕ ЗАБУДЬТЕ ДОБАВИТЬ СПЕЦИФИЧНЫЕ ОПЦИИ ДЛЯ ОПРЕДЕЛЕННЫХ СЕРВЕРОВ
НАПРИМЕР:

```nginx
   server {

            server_name feed.app.twc1.net;

            client_max_body_size 50M;  # максимальный размер файла 50 мегабайт

            location / {
                    proxy_pass http://localhost:3500;
                    proxy_http_version 1.1;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection 'upgrade';
                    proxy_set_header Host $host;
                    proxy_cache_bypass $http_upgrade;
                    # --- ВАЖНО! ---
                    proxy_read_timeout 600s;   # 10 минут
                    proxy_send_timeout 600s;
                    send_timeout 600s;
                    # --- ВАЖНО! ---
            }

```

Удачи в эксплуатации! Автоматизация теперь реально работает! 🚀
