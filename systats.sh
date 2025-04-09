#!/bin/bash

# Set output directory
OUTPUT_DIR="/var/tmp"

# Hostname and timestamp for uniqueness
HOST=$(hostname)
TS=$(date +%Y%m%d_%H%M%S)

# Output file paths
CPU_FILE="$OUTPUT_DIR/cpu_metrics_${HOST}_$TS.csv"
MEM_FILE="$OUTPUT_DIR/mem_metrics_${HOST}_$TS.csv"
IO_FILE="$OUTPUT_DIR/io_metrics_${HOST}_$TS.csv"

# Run duration and interval
DURATION=3600  # 1 hour = 3600 seconds
INTERVAL=1     # every 1 second

# Headers
echo "Timestamp,Hostname,CPU_usr,CPU_sys,CPU_idle" > $CPU_FILE
echo "Timestamp,Hostname,Mem_total_MB,Mem_used_MB,Mem_free_MB,Mem_available_MB" > $MEM_FILE
echo "Timestamp,Hostname,Disk_Device,Disk_r/s,Disk_w/s,Disk_rkB/s,Disk_wkB/s,Disk_util%" > $IO_FILE

# Capture metrics
for ((i=0; i<$DURATION; i++)); do
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  # CPU
  read CPU_USR CPU_SYS CPU_IDLE <<< $(mpstat 1 1 | awk '/all/ {print $3, $5, $13}')
  echo "$TIMESTAMP,$HOST,$CPU_USR,$CPU_SYS,$CPU_IDLE" >> $CPU_FILE

  # Memory
  read MEM_TOTAL MEM_USED MEM_FREE MEM_AVAIL <<< $(free -m | awk '/Mem:/ {print $2, $3, $4, $7}')
  echo "$TIMESTAMP,$HOST,$MEM_TOTAL,$MEM_USED,$MEM_FREE,$MEM_AVAIL" >> $MEM_FILE

  # Disk I/O
  iostat -dxm 1 1 | awk -v ts="$TIMESTAMP" -v h="$HOST" \
    '/^sd|^nvme/ {
      printf "%s,%s,%s,%.2f,%.2f,%.2f,%.2f,%.2f\n", ts, h, $1, $4, $5, $6, $7, $NF
    }' >> $IO_FILE

done
