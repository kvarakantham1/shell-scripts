# Linux System Metrics Collector

A lightweight Bash script that collects system performance metrics (CPU, memory, and disk I/O) on Linux servers. Useful for diagnostics, performance monitoring, and comparing resource usage across nodes in a distributed environment.

## 📦 What It Does

- Captures CPU, memory, and disk I/O metrics every **1 second**
- Logs data for **1 hour** by default
- Outputs results to `/var/tmp` as CSV files, one for each metric type
- Appends **hostname** and **timestamp** to filenames for clarity across nodes
- Compatible with tools like Excel, Grafana, or any log aggregation platform

## 📁 Output Files

Files are created in `/var/tmp/` with this naming pattern:

- `cpu_metrics_<hostname>_<timestamp>.csv`
- `mem_metrics_<hostname>_<timestamp>.csv`
- `io_metrics_<hostname>_<timestamp>.csv`

Each file contains time-series data with a row every second.

## 📋 Sample Output

**CPU Metrics:**
Timestamp,Hostname,CPU_usr,CPU_sys,CPU_idle 2025-04-08 14:00:01,node1,3.45,1.25,95.00

**Memory Metrics:**
Timestamp,Hostname,Mem_total_MB,Mem_used_MB,Mem_free_MB,Mem_available_MB 2025-04-08 14:00:01,node1,32110,25480,3100,4200

**Disk I/O Metrics:**
Timestamp,Hostname,Disk_Device,Disk_r/s,Disk_w/s,Disk_rkB/s,Disk_wkB/s,Disk_util% 2025-04-08 14:00:01,node1,sda,10.25,3.12,1000.00,300.00,12.50

## 🚀 Running the Script

### Locally

chmod +x monitor.sh
./monitor.sh

Remotely on Multiple Servers (Using clush)

clush -g myservers -c ./monitor.sh --dest /tmp/monitor.sh
clush -g myservers "nohup bash /tmp/monitor.sh > /tmp/monitor.log 2>&1 &"

**Requirements**
Linux system with:
mpstat (from sysstat)
free (usually from procps-ng)
iostat (from sysstat)

To install dependencies:
sudo apt install sysstat procps      # Debian/Ubuntu
sudo yum install sysstat procps-ng   # RHEL/CentOS

**Customization**
You can edit the script to:
Change duration (DURATION=3600)
Change sampling interval (INTERVAL=1)
Modify output directory (/var/tmp)

**Note**
The script is very lightweight but may generate large CSVs over time.
Ensure sufficient disk space in /var/tmp, especially when running on many nodes.

