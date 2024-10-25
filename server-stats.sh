#!/bin/bash

# Check if required commands are available
for cmd in mpstat jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "$cmd could not be found. please install it"
    exit 1
  fi
done

# ------------- Stat Gather Functions ---------------
function get_cpu_stats() {
  # Get idle CPU percentage and subtract from 100
  cpu_idle=$(mpstat 1 1 -o JSON |
    jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0].idle')
  cpu_used=$(echo "100 - $cpu_idle" | bc)

  # Prepend 0 if usage is less than 1
  if [[ $(echo "$cpu_used < 1" | bc) == 1 ]]; then
    cpu_used="0$cpu_used"
  fi
}

# Get Memory Total, Free, and Used
function get_memory_stats() {
  memory_used=$(free -ht | grep "Total" | awk '{print $3}')
  memory_free=$(free -ht | grep "Total" | awk '{print $4}')
}

# Get 5 CPU using processes
function get_top_5_cpu() {
  # Capture the top output, remove headers, and limit to top 5 processes by CPU usage
  top_output=$(top -b -n1 -o %CPU | sed -e '1,7d' -e '13,$d' |
    awk '{printf "%-15s %5.1f\n", $12, $9}')

}

# ------------- Display Functions ---------------
function display_heading() {
  echo "==================="
  echo " System Resources "
  echo "==================="
}

function display_cpu() {
  get_cpu_stats
  printf "%-12s %8s%%\n" "CPU Used:" "$cpu_used"
  printf "%-12s %8s%%\n" "CPU Free:" "$cpu_idle"
}

function display_memory() {
  get_memory_stats
  printf "%-12s %9s\n" "Memory Used:" "$memory_used"
  printf "%-12s %9s\n" "Memory Free:" "$memory_free"
}

function display_top_5_cpu() {
  get_top_5_cpu
  echo "======================"
  echo " Top 5 CPU Processes "
  echo "======================"
  echo ""

  printf "%-15s %-5s\n" "COMMAND" "%CPU"
  printf "%s\n" "$top_output"
}

display_heading
echo ""
display_memory
display_cpu
echo ""
display_top_5_cpu
