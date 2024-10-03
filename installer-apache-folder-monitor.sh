#!/bin/bash

# Variables
SERVICE_NAME="webserver-folder-monitor"
SCRIPT_PATH="/usr/local/bin/webserver-folder-monitor.sh"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
NFS_FOLDER="/mnt/efs/fs1/"  # Folder to monitor. Change this path as needed.

# Function to check if md5sum is available
check_md5sum() {
    if ! command -v md5sum >/dev/null 2>&1; then
        echo "Error: md5sum is not installed. Aborting installation."
        exit 1
    fi
}

# Function to detect the web server and Linux distribution
detect_system() {
    if command -v httpd >/dev/null 2>&1; then
        WEB_SERVER="httpd"
    elif command -v apache2 >/dev/null 2>&1; then
        WEB_SERVER="apache2"
    elif command -v nginx >/dev/null 2>&1; then
        WEB_SERVER="nginx"
    else
        echo "Error: No supported web server (httpd, apache2, or nginx) found. Aborting installation."
        exit 1
    fi

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    else
        OS=$(uname -s)
    fi

    echo "Detected web server: $WEB_SERVER"
    echo "Detected OS: $OS"
}

# Function to create the monitoring script
create_monitoring_script() {
    cat << EOF > $SCRIPT_PATH
#!/bin/bash

NFS_FOLDER="$NFS_FOLDER"
CHECK_INTERVAL=5  # Check every 5 seconds
LOG_FILE="/var/log/webserver-folder-monitor.log"
MAX_LOG_SIZE=$((1024 * 1024))  # 1MB in bytes
WEB_SERVER="$WEB_SERVER"

previous_hash=""

# Function to rotate log file
rotate_log() {
    if [ -f "\$LOG_FILE" ] && [ \$(stat -c%s "\$LOG_FILE") -ge \$MAX_LOG_SIZE ]; then
        mv "\$LOG_FILE" "\$LOG_FILE.old"
        touch "\$LOG_FILE"
        chmod 644 "\$LOG_FILE"
        echo "\$(date '+%Y-%m-%d %H:%M:%S') - Log file rotated" >> "\$LOG_FILE"
    fi
}

# Function to restart the web server
restart_web_server() {
    echo "\$(date '+%Y-%m-%d %H:%M:%S') - Restarting \$WEB_SERVER..." >> "\$LOG_FILE"
    systemctl restart \$WEB_SERVER >> "\$LOG_FILE" 2>&1
}

while true; do
    # Rotate log if necessary
    rotate_log

    # Compute the hash of all files within the NFS folder
    current_hash=\$(find "\$NFS_FOLDER" -type f -exec md5sum {} + 2>/dev/null | sort | md5sum | awk '{print \$1}')

    if [ "\$current_hash" != "\$previous_hash" ]; then
        # Check if the log file exists; if not, create it
        if [ ! -f "\$LOG_FILE" ]; then
            touch "\$LOG_FILE"
            chmod 644 "\$LOG_FILE"
            echo "\$(date '+%Y-%m-%d %H:%M:%S') - Log file created at \$LOG_FILE" >> "\$LOG_FILE"
        fi

        # Log the changes detected and restart the web server
        echo "\$(date '+%Y-%m-%d %H:%M:%S') - Changes detected in \$NFS_FOLDER" >> "\$LOG_FILE"
        restart_web_server

        echo "\$(date '+%Y-%m-%d %H:%M:%S') - File Updated: \$current_hash" >> "\$LOG_FILE"

        # Update the hash
        previous_hash="\$current_hash"
    fi

    sleep \$CHECK_INTERVAL
done
EOF

    # Make the script executable
    chmod +x $SCRIPT_PATH
}

# Function to create systemd service file
create_systemd_service() {
    cat << EOF > $SERVICE_FILE
[Unit]
Description=Web Server Folder Monitor Service
After=network.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Set proper permissions for the service file
    chmod 644 $SERVICE_FILE
}

# Function to enable and start the systemd service
enable_and_start_service() {
    # Reload systemd to recognize the new service
    systemctl daemon-reload

    # Enable the service to start at boot
    systemctl enable $SERVICE_NAME

    # Start the service
    systemctl start $SERVICE_NAME

    echo "Installation complete. The service is running and will start on reboot."
}

# Main installation flow
check_md5sum
detect_system
create_monitoring_script
create_systemd_service
enable_and_start_service
