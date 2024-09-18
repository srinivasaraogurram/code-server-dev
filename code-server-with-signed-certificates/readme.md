Great — below is a **step-by-step guide** to:

---

✅ **Install `code-server` natively (no Docker)**
🔐 **Enable HTTPS access using a self-signed certificate**
🌐 **Access code-server securely over your LAN**

---

## 🧰 System: Ubuntu (e.g., on ODROID M1)

---

## ✅ Step 1: Install code-server Natively

### 1. Update & install dependencies

```bash
sudo apt update && sudo apt install -y curl
```

### 2. Install code-server using the official script

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

This installs the binary to `/usr/bin/code-server` and sets up a systemd service.

---

## ✅ Step 2: Configure code-server for Password Auth & LAN Access

### 1. Open the config file

```bash
nano ~/.config/code-server/config.yaml
```

### 2. Update it to look like this:

```yaml
bind-addr: 0.0.0.0:3000
auth: password
password: yoursecurepassword
cert: false
```

> `0.0.0.0` allows connections from any machine in your LAN.
> Change `yoursecurepassword` to something strong.

Save and exit: `Ctrl+O`, `Enter`, `Ctrl+X`

---

## ✅ Step 3: Generate a Self-Signed SSL Certificate

### 1. Create a certs folder

```bash
mkdir -p ~/.certs
```

### 2. Generate a self-signed certificate

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ~/.certs/code-server.key \
  -out ~/.certs/code-server.crt \
  -subj "/CN=your-lan-ip"
```

> Replace `your-lan-ip` with your ODROID’s IP (e.g. `192.168.1.50`)

---

## ✅ Step 4: Enable HTTPS in code-server

### 1. Edit the config again

```bash
nano ~/.config/code-server/config.yaml
```

Update it like this:

```yaml
bind-addr: 0.0.0.0:3000
auth: password
password: yoursecurepassword
cert: /home/sri/.certs/code-server.crt
cert-key: /home/sri/.certs/code-server.key
```

> Adjust the path to match your actual user (e.g., `/home/sri/...`).

Save and exit.

---

## ✅ Step 5: Start code-server

### Start it manually:

```bash
code-server
```

OR enable and start the background service:

```bash
systemctl --user enable --now code-server
```

---

## ✅ Step 6: Access it from Another Device

### From another computer on the same LAN, open:

```
https://192.168.1.50:3000
```

> ⚠️ You’ll get a **browser warning** (self-signed cert). Click **Advanced → Proceed**.

Log in using your password.

---

## 🛠 Optional: Auto-start on Boot (for systemd-based systems)

If you want `code-server` to auto-start at boot:

```bash
sudo loginctl enable-linger $USER
```

This keeps your user’s systemd services running even after logout.

---

## ✅ Summary

| Task                | Command / File                                        |
| ------------------- | ----------------------------------------------------- |
| Install code-server | `curl -fsSL https://code-server.dev/install.sh \| sh` |
| Config file         | `~/.config/code-server/config.yaml`                   |
| Generate certs      | `openssl req -x509 ...`                               |
| Start code-server   | `code-server` or `systemctl --user start code-server` |
| Access on LAN       | `https://<your-device-ip>:3000`                       |

---

Let me know if you'd like to:

* Use a domain (e.g., with `dnsmasq`)
* Use a real SSL cert (e.g., via Let’s Encrypt + reverse proxy)
* Secure it further (fail2ban, firewall, etc.)
