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
