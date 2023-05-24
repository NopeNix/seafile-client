#!/bin/bash

# Initializing and starting Seafile
echo "Initializing and starting Seafile..."
seaf-cli init -d /app/seafiles
seaf-cli start
echo ""

# Wait for System to be stable
echo "Waiting for 5 seconds for seafile to stabilize..."
sleep 5
echo ""

# Download and sync a library from a server.
cd /app/seafiles
echo "DOWNLOADING:"
echo "      SERVER          : $SERVER"
echo "      LIBRARY         : $LIB_ID"
echo "      LOCATION        : /app/seafiles/"
echo "      SEAFILE USER    : $SEAFILE_USERNAME"
echo ""
seaf-cli sync -l "$LIB_ID" -d /app/lib -s "$SERVER" -u "$SEAFILE_USERNAME" -p "$SEAFILE_PASSWORD"
echo ""

# Watching Seafile Log
echo "Showing Seafile Log from hereon..."
# Below output is from ChatGPT
logfile="/root/.ccnet/logs/seafile.log"

# Store the current number of lines in the log file
num_lines=$(wc -l < "$logfile")

# Monitor the log file for changes
while true; do
    # Wait for file modifications using inotifywait
    inotifywait -qq -e modify "$logfile" > /dev/null 2>&1
    
    # Get the new number of lines in the log file
    new_num_lines=$(wc -l < "$logfile")

    if [ "$new_num_lines" -gt "$num_lines" ]; then
        # Calculate the number of new lines added
        added_lines=$((new_num_lines - num_lines))

        # Print the new lines
        tail -n "$added_lines" "$logfile"

        # Update the stored number of lines
        num_lines="$new_num_lines"
    fi
done