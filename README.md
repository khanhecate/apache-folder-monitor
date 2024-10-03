# Apache Folder Monitor

Apache Folder Monitor is a bash script that sets up a systemd service to monitor a specified NFS folder for changes and automatically reload the Apache web server when changes are detected.

## Features

- Monitors a specified NFS folder for file changes
- Automatically reloads Apache when changes are detected
- Runs as a systemd service for reliable operation
- Logs all activities for easy troubleshooting

## Prerequisites

- A Linux system with systemd
- Apache2 web server installed and configured
- `md5sum` utility installed (usually pre-installed on most Linux distributions)
- Root or sudo access

## Installation

1. Download the installation script:
   ```
   wget https://example.com/path/to/install-apache-folder-monitor.sh
   ```

2. Make the script executable:
   ```
   chmod +x install-apache-folder-monitor.sh
   ```

3. Run the installation script with root privileges:
   ```
   sudo ./install-apache-folder-monitor.sh
   ```

The script will:
- Create the monitoring script at `/usr/local/bin/apache-folder-monitor.sh`
- Set up a systemd service named `apache-folder-monitor`
- Enable and start the service

## Configuration

The main configuration is done in the installation script. You can modify the following variables before running the installation:

- `NFS_FOLDER`: The path to the folder you want to monitor (default: `/mnt/efs/fs1/`)
- `CHECK_INTERVAL`: The interval between checks in seconds (default: 5)
- `LOG_FILE`: The location of the log file (default: `/tmp/apache-folder-monitor.log`)

To change these settings after installation:

1. Edit the monitoring script:
   ```
   sudo nano /usr/local/bin/apache-folder-monitor.sh
   ```

2. Modify the variables as needed.

3. Save the file and exit the editor.

4. Restart the service:
   ```
   sudo systemctl restart apache-folder-monitor
   ```

## Usage

The service starts automatically after installation and on system boot. You can manage it using standard systemd commands:

- Check status: `sudo systemctl status apache-folder-monitor`
- Stop service: `sudo systemctl stop apache-folder-monitor`
- Start service: `sudo systemctl start apache-folder-monitor`
- Disable service: `sudo systemctl disable apache-folder-monitor`
- Enable service: `sudo systemctl enable apache-folder-monitor`

## Logs

You can view the logs to see detected changes and Apache reload events:

```
sudo tail -f /tmp/apache-folder-monitor.log
```

## Uninstallation

To uninstall the Apache Folder Monitor:

1. Stop and disable the service:
   ```
   sudo systemctl stop apache-folder-monitor
   sudo systemctl disable apache-folder-monitor
   ```

2. Remove the service file:
   ```
   sudo rm /etc/systemd/system/apache-folder-monitor.service
   ```

3. Remove the monitoring script:
   ```
   sudo rm /usr/local/bin/apache-folder-monitor.sh
   ```

4. Reload systemd to apply changes:
   ```
   sudo systemctl daemon-reload
   ```

5. Optionally, remove the log file:
   ```
   sudo rm /tmp/apache-folder-monitor.log
   ```

## Troubleshooting

- If the service fails to start, check the system logs:
  ```
  sudo journalctl -u apache-folder-monitor
  ```

- Ensure the NFS folder is properly mounted and accessible.
- Verify that Apache is installed and configured correctly.

## Support

For issues, questions, or contributions, please open an issue in the project repository or contact the maintainer.

