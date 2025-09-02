# 🚀 nginx-domain-provisioner

Утилита для автоматизированного создания, настройки и управления поддоменами на VDS с помощью **Nginx** и бесплатных SSL-сертификатов (**Let’s Encrypt, Certbot**).

## ✨ Возможности

- Автоматическое создание nginx-конфигов для поддоменов
- Настройка HTTPS через Certbot за одну команду
- Гибкая IP-фильтрация доступа (через отдельный файл)
- Автоматическое продление сертификатов (ничего вручную делать не требуется)
- Удобное удаление поддоменов и сертификатов

## 📂 Структура проекта

```bash
nginx-domain-provisioner/
├── add_subdomain.sh              # основной автоматизированный скрипт
├── includes/
│   ├── allowed_ips.conf          # список разрешённых IP
│   └── no_ip_restriction.conf    # пустой include (для открытых сервисов)
├── README.md                     # документация для пользователей
└── SETUP.md                      # пошаговая памятка по установке и обслуживанию
```

## ⚡️ Возможности

- ✅ Автоматическая генерация конфигов для поддоменов.
- ✅ Настройка HTTPS с Certbot.
- ✅ Автоматическая перезагрузка Nginx.
- ✅ Опциональная IP-фильтрация (`allow/deny`).
- ✅ Поддержка **любых доменов и поддоменов**.
- ✅ Удобная очистка (удаление поддомена + сертификата).

## 🛠 Быстрый старт

На **Ubuntu 20.04/22.04/24.04**:

### 1. Клонируйте репозиторий и настройте права

```bash
# Склонировать репозиторий
git clone https://github.com/yourname/nginx-domain-provisioner.git
cd nginx-domain-provisioner
chmod +x add_subdomain.sh
```

### 2. Установить зависимости (если ещё не стоят)

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

### 3. Настройте файлы IP-фильтрации

```bash
sudo mkdir -p /etc/nginx/includes

# Пример ограниченного доступа
sudo nano /etc/nginx/includes/allowed_ips.conf
# Пример содержимого:
allow 77.51.44.117;   # JOB
allow 89.188.168.102; # HOME
allow 172.18.0.0/16;  # Docker
deny all;
# Для публичных сервисов создаем пустой конфиг
sudo touch /etc/nginx/includes/no_ip_restriction.conf
```

### 4. Добавьте поддомен

- Публичный (без ограничений):

```bash
  sudo ./add_subdomain.sh read.app.tw1.ru 3000 no
```

- С фильтрацией по IP:

```bash
sudo ./add_subdomain.sh feed.app.tw1.ru 3000 yes
```

### 5. Проверьте работу

- Проверить DNS-запись:

```bash
dig +short app.crm-tg-mini-app.tw1.ru
```

- Проверить nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 6. Готово

- Сертификаты продлеваются автоматически (см. SETUP.md).
- Для новых поддоменов — просто повторяй шаг 4.
- Для смены IP-доступа — меняй только allowed_ips.conf и делай systemctl reload nginx.

## 🧹 Удаление поддомена

```bash
sudo rm /etc/nginx/sites-enabled/<domain>.conf
sudo rm /etc/nginx/sites-available/<domain>.conf
sudo certbot delete --cert-name <domain>
sudo systemctl reload nginx
```

## 💡 Полная инструкция — смотри SETUP.md

MIT License © 2025
