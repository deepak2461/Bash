#!/bin/bash
# Script Name: solution1.sh
# Description:
#   - Go through all server_*.log files in the current directory
#   - Extract ERROR entries from the last 24 hours
#   - Save them to error_summary.txt in format: FILENAME:TIMESTAMP:MESSAGE
#   - Archive logs older than 7 days into archive.tar.gz and delete them
#
# Note:
#   CURRENT_TIME env variable can be set for testing, otherwise script uses system time.

# Use CURRENT_TIME if provided, otherwise default to now
if [ -z "$CURRENT_TIME" ]; then
    CURRENT_TIME=$(date +%s)
fi

ONE_DAY_AGO=$((CURRENT_TIME - 86400))  # 86400 seconds = 24 hours
ERROR_FILE="error_summary.txt"

# Clear old output file if it exists
> "$ERROR_FILE"

# Process each log file
for logfile in server_*.log; do
    # Skip if no files match
    [ -e "$logfile" ] || continue

    while read -r line; do
        # Example line format: [2025-09-23 14:22:10] ERROR Something bad happened
        ts=$(echo "$line" | awk '{print $1 " " $2}' | tr -d '[]')
        level=$(echo "$line" | awk '{print $3}')
        message=$(echo "$line" | cut -d' ' -f4-)

        # Convert timestamp to epoch, ignore line if conversion fails
        ts_epoch=$(date -d "$ts" +%s 2>/dev/null)
        if [ -z "$ts_epoch" ]; then
            continue
        fi

        # Check if entry is ERROR and within last 24 hours
        if [ "$level" = "ERROR" ] && [ "$ts_epoch" -ge "$ONE_DAY_AGO" ]; then
            echo "$logfile:$ts:$message" >> "$ERROR_FILE"
        fi
    done < "$logfile"
done

# Archive and remove logs older than 7 days
old_logs=$(find . -name "server_*.log" -type f -mtime +7)
if [ -n "$old_logs" ]; then
    tar -czf archive.tar.gz $old_logs
    rm -f $old_logs
fi

echo "Processing complete. Errors saved in $ERROR_FILE"
