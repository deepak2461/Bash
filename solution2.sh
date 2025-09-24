#!/bin/bash

# Get current time from env variable or use a default
CURRENT_TIME=${CURRENT_TIME:-"2025-09-24 19:00:00"}
current_epoch=$(date -d "$CURRENT_TIME" +%s)

# Clear the output file
> error_summary.txt

# Loop through all server_*.log files
for log_file in server_*.log
do
    # Skip if file doesn't exist
    if [ -f "$log_file" ]; then
        # Read each line in the log file
        while read -r line; do
            # Grab timestamp, level, and message
            timestamp=$(echo "$line" | cut -d' ' -f1,2 | tr -d '[]')
            level=$(echo "$line" | cut -d' ' -f3)
            message=$(echo "$line" | cut -d' ' -f4-)
            
            # Check if it's an ERROR line
            if [ "$level" = "ERROR" ]; then
                # Convert timestamp to epoch for comparison
                log_epoch=$(date -d "$timestamp" +%s 2>/dev/null)
                # Check if error is within last 24 hours (86400 seconds)
                if [ $((current_epoch - log_epoch)) -le 86400 ]; then
                    echo "$log_file:$timestamp:$message" >> error_summary.txt
                fi
            fi
        done < "$log_file"
    fi
done

# Sort the error summary by timestamp
if [ -s error_summary.txt ]; then
    sort -t':' -k2 error_summary.txt > temp.txt
    mv temp.txt error_summary.txt
fi

# Find and archive logs older than 7 days
for log_file in server_*.log
do
    if [ -f "$log_file" ]; then
        # Get file modification time
        file_mtime=$(stat -c %Y "$log_file")
        # Check if older than 7 days (604800 seconds)
        if [ $((current_epoch - file_mtime)) -gt 604800 ]; then
            # Add to tar archive
            tar -rf archive.tar.gz "$log_file" 2>/dev/null
            # Delete the original file
            rm "$log_file"
        fi
    fi
done

# Compress the tar archive if it exists
if [ -f archive.tar.gz ]; then
    gzip archive.tar.gz
fi