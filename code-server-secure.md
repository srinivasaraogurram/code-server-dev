To set up a secure Code Server environment (VSCode in the browser) without a domain and using an IP address on your local LAN and Wi-Fi, you need to configure HTTPS using a self-signed certificate or access it over HTTP for local access.

### Steps to configure:

#### 1. **Install Code Server**

If you haven’t installed Code Server, follow these steps on your Raspberry Pi or server:

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

#### 2. **Configure Code Server**

Modify the Code Server configuration to bind to your LAN IP address:

```bash
nano ~/.config/code-server/config.yaml
```

Update the file with the following:

```yaml
bind-addr: 0.0.0.0:8080  # Allows access from any IP in your LAN on port 8080
auth: password  # Use password for authentication
password: your-secure-password
cert: false  # HTTPS not enabled for local use
```

If you prefer HTTPS (recommended for security), you'll need to generate a self-signed certificate or use Let's Encrypt if your IP is public. For local use, self-signed is enough.

#### 3. **Generate a Self-Signed Certificate (Optional for HTTPS)**

To use HTTPS with a self-signed certificate, run the following commands:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout code-server.key -out code-server.crt
```

This will prompt you to enter some details. After that, move the certificate and key to a secure location.

Update the `config.yaml` file:

```yaml
bind-addr: 0.0.0.0:8080
auth: password
password: your-secure-password
cert: true
cert-key: /path/to/code-server.key
cert-file: /path/to/code-server.crt
```

#### 4. **Start Code Server**

You can now start Code Server:

```bash
code-server
```

#### 5. **Access Code Server**

On any device connected to your local network, you can access Code Server by opening a browser and navigating to:

- **HTTP**: `http://192.168.x.x:8080`
- **HTTPS** (with self-signed certificate): `https://192.168.x.x:8080`

Replace `192.168.x.x` with your Raspberry Pi or server's local IP address.

#### 6. **Allow Firewall Access**

Make sure to allow the necessary ports through your firewall. For example, on Ubuntu, use:

```bash
sudo ufw allow 8080/tcp
```

If you're using HTTPS, browsers might warn about the self-signed certificate. You can ignore the warning for local development purposes. If you need remote access, consider using a VPN for better security.

This setup will work over your local LAN or Wi-Fi. Let me know if you need more details or have specific security requirements!



It seems that the error you're encountering is due to a misconfiguration in the `config.yaml` file. The `--cert-file` and `--cert-key` options are not valid in the latest version of Code Server.

Here’s the corrected configuration:

### Correct `config.yaml` Configuration for HTTPS:
```yaml
bind-addr: 0.0.0.0:8080
auth: password
password: your-secure-password
cert: true  # Enables HTTPS
cert-key: /home/sri/.config/code-server/code-server.key  # Path to your key file
cert-file: /home/sri/.config/code-server/code-server.crt  # Path to your certificate file
```

If Code Server does not support specifying `cert-file` and `cert-key` directly in the YAML, you can run it with these options directly from the command line instead.

### Running Code Server with HTTPS on the Command Line:

```bash
code-server --bind-addr 0.0.0.0:8080 --cert --cert-key /home/sri/.config/code-server/code-server.key --cert-file /home/sri/.config/code-server/code-server.crt
```

### Additional Troubleshooting:
1. Make sure that the `.key` and `.crt` files exist and are correctly generated.
2. If you still encounter issues, you can opt for reverse proxying using Nginx or Caddy, which handles the certificates more gracefully, allowing Code Server to run behind them.

Let me know if you'd like help with setting up a reverse proxy or have any further questions!
