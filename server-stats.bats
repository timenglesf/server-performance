#!/usr/bin/env bats

# Load the script to be tested
load ./server-stats.sh

# Mock functions to simulate the actual behavior
function get_cpu_stats() {
  cpu_used=30
  cpu_idle=70
}

function get_memory_stats() {
  memory_used="2G"
  memory_free="6G"
  memory_available="4G"
}

function get_top_5_cpu() {
  top_output="COMMAND         %CPU\nprocess1       10\nprocess2       8\nprocess3       7\nprocess4       5\nprocess5       4"
}

@test "display_heading" {
  run display_heading
  [ "$status" -eq 0 ]
  [ "$output" == "===================\n System Resources \n===================" ]
}

@test "display_cpu" {
  get_cpu_stats
  run display_cpu
  [ "$status" -eq 0 ]
  [ "$output" == "CPU Used:             30%\nCPU Free:             70%" ]
}

@test "display_memory" {
  get_memory_stats
  run display_memory
  [ "$status" -eq 0 ]
  [ "$output" == "Memory Used:          2G\nMemory Free:          6G\nMemory Available:     4G" ]
}

@test "display_top_5_cpu" {
  get_top_5_cpu
  run display_top_5_cpu
  [ "$status" -eq 0 ]
  [ "$output" == "======================\n Top 5 CPU Processes \n======================\n\nCOMMAND         %CPU\nprocess1       10\nprocess2       8\nprocess3       7\nprocess4       5\nprocess5       4" ]
}
