# Linux Server Peroformance Statistics

## Server Performance Status Script

This Bash script provides a quick overview of the server's performance by displaying CPU and memory usage, as well as the top 5 processes consuming the most CPU.

### Features

- **CPU Usage**: Displays the percentage of CPU used and idle.
- **Memory Usage**: Shows the total memory used and free.
- **Top CPU Processes**: Lists the top 5 processes consuming the most CPU.

### Prerequisites

Ensure the following commands are available on your system:

- `mpstat`
- `jq`
- `free`
- `top`

### Usage

Run the script using the following command:

```sh
./server-stats.sh
```

The script will output the system's CPU and memory usage, along with the top 5 CPU-consuming processes.

---
