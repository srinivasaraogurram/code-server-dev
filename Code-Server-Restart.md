To restart Code Server, you need to stop the currently running instance and then start it again. Here’s how you can do it:

### If You Started Code Server Manually

If you started Code Server manually in a terminal, you can stop it by:

1. **Finding the Process ID (PID):**

   ```bash
   ps aux | grep code-server
   ```

   This command will list all processes related to Code Server. Note the PID from the output.

2. **Killing the Process:**

   ```bash
   kill <PID>
   ```

   Replace `<PID>` with the actual process ID you found in the previous step.

3. **Starting Code Server Again:**

   ```bash
   code-server
   ```

### If Code Server is Running as a Systemd Service

If Code Server is set up as a systemd service, you can use the following commands:

1. **Restarting Code Server:**

   ```bash
   sudo systemctl restart code-server
   ```

2. **Checking the Status:**

   ```bash
   sudo systemctl status code-server
   ```

   This will show whether Code Server is running correctly.

### If Code Server is Running with Docker

If you’re using Docker, you can restart Code Server with:

1. **Finding the Container ID:**

   ```bash
   docker ps
   ```

   This command lists all running Docker containers. Note the Container ID for Code Server.

2. **Restarting the Container:**

   ```bash
   docker restart <container_id>
   ```

   Replace `<container_id>` with the actual ID of your Code Server container.

### Ensure Configuration Changes

After restarting Code Server, make sure to check if your configuration changes are applied correctly and verify that it is accessible from your browser.

Let me know if you need help with any specific setup or further assistance!
