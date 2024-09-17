To uninstall Code Server from your Raspberry Pi 5 (or any other Linux-based system), follow these steps:

### Uninstalling Code Server

#### 1. **Stop Code Server**

If Code Server is running as a service, stop it first:

```bash
sudo systemctl stop code-server
```

If you started Code Server manually, stop it by finding the process ID (PID) and killing it:

```bash
ps aux | grep code-server
kill <PID>
```

Replace `<PID>` with the actual PID from the output.

#### 2. **Remove the Code Server Package**

If you installed Code Server using the installation script, you might need to manually remove it. There isn't an official uninstall script, but you can follow these steps:

1. **Remove the Code Server Binary**

   The binary is typically located in `/usr/local/bin`:

   ```bash
   sudo rm /usr/local/bin/code-server
   ```

2. **Remove Configuration Files**

   Delete the configuration directory:

   ```bash
   rm -rf ~/.config/code-server
   ```

3. **Remove Systemd Service**

   If you set up Code Server as a systemd service, remove the service file:

   ```bash
   sudo rm /etc/systemd/system/code-server.service
   ```

   Then, reload systemd to apply the changes:

   ```bash
   sudo systemctl daemon-reload
   ```

#### 3. **Remove Any Remaining Files**

There might be other directories or files related to Code Server. Check and remove any remaining Code Server files if needed:

```bash
find / -name '*code-server*' -exec sudo rm -rf {} +
```

#### 4. **Clean Up Dependencies**

If you installed any additional dependencies specifically for Code Server and no longer need them, you can remove those as well. For example:

```bash
sudo apt-get autoremove
```

### Verify Uninstallation

Make sure Code Server is completely removed by checking:

- The binary file is no longer present in `/usr/local/bin`.
- The configuration directory is removed.
- The systemd service file is deleted.

If you need any further assistance or encounter specific issues during the uninstallation, let me know!
