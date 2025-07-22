# Code Server Setup with HTTPS and Nginx on Ubuntu (LAN Deployment)

This document outlines the step-by-step setup of Code Server on Ubuntu with Nginx reverse proxy and HTTPS support. It is optimized for use on a local network (LAN), using a dynamic IP or hostname.

---

## ✅ Stage 1: Base OS Setup

* **OS**: Ubuntu (latest LTS recommended)

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget git unzip -y
```

---

## ✅ Stage 2: Install Prerequisites

### 1. Docker & Docker Compose

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
sudo apt install docker-compose-plugin -y
```

### 2. SDKMAN + Java 8

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 8.0.392-tem
```

### 3. Maven

```bash
sdk install maven
```

### 4. Tomcat 9

```bash
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz
sudo tar -xzf apache-tomcat-9.0.86.tar.gz
sudo mv apache-tomcat-9.0.86 tomcat9
sudo chmod +x /opt/tomcat9/bin/*.sh
/opt/tomcat9/bin/startup.sh
```

---

## ✅ Stage 3: Code Server Setup

### 1. Install Code Server

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

### 2. Configure Code Server

```bash
mkdir -p ~/.config/code-server
nano ~/.config/code-server/config.yaml
```

Contents:

```yaml
bind-addr: 127.0.0.1:3000
auth: none
cert: false
```

### 3. Start Code Server

```bash
sudo systemctl restart code-server@$USER
sudo systemctl enable code-server@$USER
```

---

## ✅ Stage 4: Nginx Reverse Proxy with HTTPS

### 1. Install Nginx

```bash
sudo apt install nginx -y
```

### 2. Generate Self-Signed SSL Certificate

```bash
sudo openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/code-server.key \
  -out /etc/ssl/certs/code-server.crt \
  -subj "/CN=localhost"
```

### 3. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/code-server
```

Paste:

```nginx
server {
    listen 80 default_server;
    server_name _;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl default_server;
    server_name _;

    ssl_certificate /etc/ssl/certs/code-server.crt;
    ssl_certificate_key /etc/ssl/private/code-server.key;

    location / {
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### 4. Enable Site and Reload Nginx

```bash
sudo ln -sf /etc/nginx/sites-available/code-server /etc/nginx/sites-enabled/code-server
sudo rm -f /etc/nginx/sites-enabled/*casaos-code-server*
sudo nginx -t
sudo systemctl reload nginx
```

---

## ✅ Stage 5: LAN Access & Hostname Support

### 1. Allow LAN Traffic

```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

### 2. Enable Hostname Access via `.local`

```bash
sudo apt install avahi-daemon -y
sudo systemctl enable --now avahi-daemon
```

Now accessible via:

* `https://<current LAN IP>`
* `https://<hostname>.local` (e.g., `sri-odroid-h3.local`)

---

✅ Setup complete and verified working over HTTPS. Next steps can include:

* DevContainer support
* Docker socket mounting
* VSCode extensions for Java, Maven, etc.
