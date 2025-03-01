#!/bin/bash

# Define variables with timestamp for uniqueness
LOG_DIR="/tmp/logs_temp"
ARCHIVE_FILE="$HOME/logs_$(date +%Y%m%d_%H%M%S).tar.gz"

# Simple permission check
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs sudo privileges to access system logs."
    echo "Please run with: sudo $0"
    exit 1
fi

# Create temporary directory
mkdir -p $LOG_DIR

echo "Collecting system logs..."

# Collect only the most commonly useful logs for a personal machine
# System logs
cp /var/log/syslog $LOG_DIR/syslog.log 2>/dev/null && echo "✓ Collected syslog" || echo "✗ Syslog not available"

# Authentication logs (useful for security)
cp /var/log/auth.log $LOG_DIR/auth.log 2>/dev/null && echo "✓ Collected auth.log" || echo "✗ Auth.log not available"

# Kernel logs (useful for hardware issues)
cp /var/log/kern.log $LOG_DIR/kern.log 2>/dev/null && echo "✓ Collected kern.log" || echo "✗ Kern.log not available"

# Desktop environment logs (if you use a GUI)
cp ~/.xsession-errors $LOG_DIR/xsession-errors.log 2>/dev/null && echo "✓ Collected X session errors" || echo "✗ X session errors not available"

# Compress logs
echo "Creating archive at $ARCHIVE_FILE"
tar -czf $ARCHIVE_FILE -C $LOG_DIR .

# Clean up
rm -rf $LOG_DIR

echo "Done! Log archive created at $ARCHIVE_FILE"
