# 🚀 nginx-domain-provisioner

Утилита для автоматического развёртывания поддоменов на VDS с **Nginx** и бесплатными SSL-сертификатами (**Let’s Encrypt, Certbot**).  

Проект позволяет в одну команду:
- создать конфиг для поддомена;
- настроить проксирование на локальный порт;
- выдать и подключить SSL-сертификат;
- включить или отключить **IP-фильтрацию**.

## 📂 Структура проекта

```
.
└── nginx-domain-provisioner/
    ├── add_subdomain.sh             # основной скрипт
    ├── includes/
    │   ├── allowed_ips.conf          # список разрешённых IP
    │   └── no_ip_restriction.conf    # пустой include (без ограничений)
    └── README.md                     # документация
```


**⚡️ Возможности**

- ✅ Автоматическая генерация конфигов для поддоменов.
- ✅ Настройка HTTPS с Certbot.
- ✅ Автоматическая перезагрузка Nginx.
- ✅ Опциональная IP-фильтрация (`allow/deny`).
- ✅ Поддержка **любых доменов и поддоменов**.
- ✅ Удобная очистка (удаление поддомена + сертификата).

**🛠 Установка**

На **Ubuntu 20.04/22.04/24.04**:

```bash
# Склонировать репозиторий
git clone https://github.com/yourname/nginx-domain-provisioner.git
cd nginx-domain-provisioner
chmod +x add_subdomain.sh
```

Установить зависимости (если ещё не стоят):

```bash
sudo apt update
sudo apt install nginx snapd -y
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```
