# Apache Folder Monitor

Apache Folder Monitor is a bash script that sets up a systemd service to monitor a specified NFS folder for changes and automatically reload the Apache web server when changes are detected.

## Repository

This project is hosted on GitHub:

https://github.com/khanhecate/apache-folder-monitor.git

Feel free to star the repository if you find it useful, and contribute by submitting issues or pull requests.

## Features

- Monitors a specified NFS folder for file changes
- Automatically reloads Apache when changes are detected
- Runs as a systemd service for reliable operation
- Logs all activities for easy troubleshooting
- Implements log rotation to manage log file size

## Prerequisites

- A Linux system with systemd
- Apache2 web server installed and configured
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
   chmod +x install-apache-folder-monitor.sh
   ```

4. Run the installation script with root privileges:
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
- `LOG_FILE`: The location of the log file (default: `/var/log/apache-folder-monitor.log`)
- `MAX_LOG_SIZE`: The maximum size of the log file before rotation in bytes (default: 1048576, which is 1MB)

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

The script now implements log rotation to manage the log file size. When the log file reaches the specified maximum size (default 1MB), it will be rotated. The current log will be moved to `apache-folder-monitor.log.old`, and a new log file will be created.

You can view the current logs using:

```
sudo tail -f /var/log/apache-folder-monitor.log
```

To view the older, rotated logs:

```
sudo cat /var/log/apache-folder-monitor.log.old
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

5. Remove the log files:
   ```
   sudo rm /var/log/apache-folder-monitor.log*
   ```

## Troubleshooting

- If the service fails to start, check the system logs:
  ```
  sudo journalctl -u apache-folder-monitor
  ```

- Ensure the NFS folder is properly mounted and accessible.
- Verify that Apache is installed and configured correctly.
- If logs are not being written or rotated as expected, check the permissions on the `/var/log` directory and the log files.

## Contributing

Contributions to this project are welcome! Please feel free to submit issues, fork the repository and send pull requests!

## Support

For issues, questions, or contributions, please open an issue in the [GitHub repository](https://github.com/khanhecate/apache-folder-monitor/issues).

## License

[Include your chosen license here, or specify if the project is not licensed]
