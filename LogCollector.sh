#!/bin/bash

# Define the directory to store the collected logs
LOG_DIR="/tmp/logs"
mkdir -p $LOG_DIR

# Collect system logs
cp /var/log/syslog $LOG_DIR/syslog.log 2>/dev/null
cp /var/log/messages $LOG_DIR/messages.log 2>/dev/null

# Collect authentication logs
cp /var/log/auth.log $LOG_DIR/auth.log 2>/dev/null
cp /var/log/secure $LOG_DIR/secure.log 2>/dev/null

# Collect kernel logs
cp /var/log/kern.log $LOG_DIR/kern.log 2>/dev/null

# Collect boot logs
cp /var/log/boot.log $LOG_DIR/boot.log 2>/dev/null

# Collect cron logs
cp /var/log/cron.log $LOG_DIR/cron.log 2>/dev/null

# Collect mail logs
cp /var/log/mail.log $LOG_DIR/mail.log 2>/dev/null
cp /var/log/maillog $LOG_DIR/maillog.log 2>/dev/null

# Collect Xorg logs
cp /var/log/Xorg.0.log $LOG_DIR/Xorg.0.log 2>/dev/null

# Compress the collected logs into a tar.gz archive
tar -czf /tmp/logs.tar.gz -C $LOG_DIR .

# Clean up
rm -rf $LOG_DIR

echo "Logs have been collected and compressed into /tmp/logs.tar.gz"