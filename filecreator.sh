#!/bin/bash

# Create server_1.log to server_7.log
for i in {1..7}; do
    touch "server_${i}.log"
done

# Create file1.log, file2.log, filen.log
touch file1.log file2.log filen.log
echo "Created log files: server_1.log to server_7.log, file1.log, file2.log, filen.log"



# Create server_1.log with sample entries
echo -e "2025-09-24 10:00:00 INFO Server started\n2025-09-24 12:00:00 ERROR Failed to connect to database\n2025-09-23 23:00:00 WARN Low memory" > server_1.log
echo -e "2025-09-25 09:15:00 INFO Backup completed\n2025-09-25 11:30:00 WARN Disk usage high" > server_2.log
echo -e "2025-09-26 08:00:00 ERROR Unable to reach API\n2025-09-26 08:05:00 INFO Retrying connection" > server_3.log
echo -e "2025-09-27 14:00:00 INFO Maintenance started" > server_4.log
echo -e "2025-09-28 16:45:00 WARN CPU temperature high\n2025-09-28 17:00:00 INFO Cooling system activated" > server_5.log
echo -e "2025-09-29 18:00:00 ERROR Out of memory" > server_6.log
echo -e "2025-09-30 19:00:00 INFO Server shutdown\n2025-09-30 19:05:00 WARN Unexpected shutdown" > server_7.log
echo -e "2025-10-01 08:00:00 INFO File processing started" > file1.log
echo -e "2025-10-02 09:00:00 ERROR File not found\n2025-10-02 09:05:00 WARN Retrying operation" > file2.log
echo -e "2025-10-03 10:00:00 INFO Log rotation completed" > filen.log

