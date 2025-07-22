Here's a full setup tailored for **Raspberry Pi 5 (ARM64)** running Ubuntu (Server or Desktop), with the same goals:

* ✅ Code Server on port `3000`
* ✅ Nginx reverse proxy with self-signed HTTPS
* ✅ Generic LAN access (no fixed IP)
* ✅ Suitable for ARM64 (all commands compatible)

---

## 📘 Code Server + Nginx + HTTPS Setup on Raspberry Pi 5 (ARM64)

---

### ✅ Stage 1: Base OS Preparation

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget git unzip -y
```

---

### ✅ Stage 2: Install Prerequisites

#### 1. Docker + Docker Compose

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
sudo apt install docker-compose-plugin -y
```

#### 2. SDKMAN + Java 8 (ARM compatible)

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 8.0.392-tem
```

#### 3. Maven

```bash
sdk install maven
```

#### 4. Tomcat 9 (ARM-safe tarball install)

```bash
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz
sudo tar -xzf apache-tomcat-9.0.86.tar.gz
sudo mv apache-tomcat-9.0.86 tomcat9
sudo chmod +x /opt/tomcat9/bin/*.sh
/opt/tomcat9/bin/startup.sh
```

---

### ✅ Stage 3: Install Code Server on Raspberry Pi 5

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

#### Configure Code Server

```bash
nano ~/.config/code-server/config.yaml
```

```yaml
bind-addr: 127.0.0.1:3000
auth: none
cert: false
```

```bash
sudo systemctl restart code-server@$USER
sudo systemctl enable code-server@$USER
```

---

### ✅ Stage 4: Nginx Reverse Proxy with HTTPS

#### 1. Install Nginx

```bash
sudo apt install nginx -y
```

#### 2. Create Self-Signed Cert

```bash
sudo openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/code-server.key \
  -out /etc/ssl/certs/code-server.crt \
  -subj "/CN=localhost"
```

#### 3. Configure Nginx Reverse Proxy

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

```bash
sudo ln -sf /etc/nginx/sites-available/code-server /etc/nginx/sites-enabled/code-server
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

---

### ✅ Stage 5: LAN Access and Hostname

#### 1. UFW LAN Ports

```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

#### 2. Optional: Avahi for `.local` Hostname

```bash
sudo apt install avahi-daemon -y
sudo systemctl enable --now avahi-daemon
```

Now accessible via:

* `https://raspberrypi.local`
* `https://<current-ip>`

---

✅ Done. Your **Raspberry Pi 5** now hosts Code Server over HTTPS with full LAN access, Java/Maven/Tomcat support, and ARM64-optimized setup.

Would you like me to save this as a separate doc or append it to the current one?
