# Web Server Folder Monitor

Web Server Folder Monitor is a bash script that sets up a systemd service to monitor a specified NFS folder for changes and automatically restart the web server (Apache, Nginx) when changes are detected. This version is compatible with multiple Linux distributions and web servers.

## Repository

This project is hosted on GitHub:

https://github.com/khanhecate/apache-folder-monitor.git

Feel free to star the repository if you find it useful, and contribute by submitting issues or pull requests.

## Features

- Monitors a specified NFS folder for file changes
- Automatically restarts the detected web server (httpd, apache2, or nginx) when changes are detected
- Runs as a systemd service for reliable operation
- Logs all activities for easy troubleshooting
- Implements log rotation to manage log file size
- Compatible with multiple Linux distributions (Amazon Linux 2, Ubuntu, Debian, CentOS, RHEL)
- Supports multiple web servers (Apache and Nginx)

## Prerequisites

- A Linux system with systemd (Amazon Linux 2, Ubuntu, Debian, CentOS, RHEL, etc.)
- Web server installed and configured (Apache or Nginx)
- `md5sum` utility installed (usually pre-installed on most Linux distributions)
- Root or sudo access

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/khanhecate/apache-folder-monitor.git
   ```

2. Change to the project directory:
   ```
   cd apache-folder-monitor
   ```

3. Make the installation script executable:
   ```
   chmod +x install-webserver-folder-monitor.sh
   ```

4. Run the installation script with root privileges:
   ```
   sudo ./install-webserver-folder-monitor.sh
   ```

The script will:
- Detect your web server (httpd, apache2, or nginx) and operating system
- Create the monitoring script at `/usr/local/bin/webserver-folder-monitor.sh`
- Set up a systemd service named `webserver-folder-monitor`
- Enable and start the service

## Configuration

The main configuration is done in the installation script. You can modify the following variables before running the installation:

- `NFS_FOLDER`: The path to the folder you want to monitor (default: `/mnt/efs/fs1/`)
- `CHECK_INTERVAL`: The interval between checks in seconds (default: 5)
- `LOG_FILE`: The location of the log file (default: `/var/log/webserver-folder-monitor.log`)
- `MAX_LOG_SIZE`: The maximum size of the log file before rotation in bytes (default: 1048576, which is 1MB)

To change these settings after installation:

1. Edit the monitoring script:
   ```
   sudo nano /usr/local/bin/webserver-folder-monitor.sh
   ```

2. Modify the variables as needed.

3. Save the file and exit the editor.

4. Restart the service:
   ```
   sudo systemctl restart webserver-folder-monitor
   ```

## Usage

The service starts automatically after installation and on system boot. You can manage it using standard systemd commands:

- Check status: `sudo systemctl status webserver-folder-monitor`
- Stop service: `sudo systemctl stop webserver-folder-monitor`
- Start service: `sudo systemctl start webserver-folder-monitor`
- Disable service: `sudo systemctl disable webserver-folder-monitor`
- Enable service: `sudo systemctl enable webserver-folder-monitor`

## Logs

The script implements log rotation to manage the log file size. When the log file reaches the specified maximum size (default 1MB), it will be rotated. The current log will be moved to `webserver-folder-monitor.log.old`, and a new log file will be created.

You can view the current logs using:

```
sudo tail -f /var/log/webserver-folder-monitor.log
```

To view the older, rotated logs:

```
sudo cat /var/log/webserver-folder-monitor.log.old
```

## Uninstallation

To uninstall the Web Server Folder Monitor:

1. Stop and disable the service:
   ```
   sudo systemctl stop webserver-folder-monitor
   sudo systemctl disable webserver-folder-monitor
   ```

2. Remove the service file:
   ```
   sudo rm /etc/systemd/system/webserver-folder-monitor.service
   ```

3. Remove the monitoring script:
   ```
   sudo rm /usr/local/bin/webserver-folder-monitor.sh
   ```

4. Reload systemd to apply changes:
   ```
   sudo systemctl daemon-reload
   ```

5. Remove the log files:
   ```
   sudo rm /var/log/webserver-folder-monitor.log*
   ```

## Troubleshooting

- If the service fails to start, check the system logs:
  ```
  sudo journalctl -u webserver-folder-monitor
  ```

- Ensure the NFS folder is properly mounted and accessible.
- Verify that your web server (Apache or Nginx) is installed and configured correctly on your system.
- If logs are not being written or rotated as expected, check the permissions on the `/var/log` directory and the log files.
- If the script is not detecting your web server correctly, you can manually set the `WEB_SERVER` variable in the script.

## Contributing

Contributions to this project are welcome! Please feel free to submit issues, fork the repository and send pull requests!

## Support

For issues, questions, or contributions, please open an issue in the [GitHub repository](https://github.com/khanhecate/apache-folder-monitor/issues).

## License

[Include your chosen license here, or specify if the project is not licensed]
