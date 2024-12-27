#!/usr/bin/env bats

# Load the script to be tested
source server-stats.sh

# Test if required commands are available
@test "Check if required commands are available" {
  run bash -c 'command -v mpstat && command -v jq > /dev/null'
  [ "$status" -eq 0 ]
}

# Test get_cpu_stats function
@test "get_cpu_stats function" {
  run bash -c 'source server-stats.sh > /dev/null && get_cpu_stats > /dev/null && echo $cpu_used $cpu_idle'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?$ ]]
}

# Test get_memory_stats function
@test "get_memory_stats function" {
  run bash -c 'source server-stats.sh > /dev/null && get_memory_stats > /dev/null && echo $memory_used $memory_free $memory_available'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]+(\.[0-9]+)?[A-Za-z]+\ [0-9]+(\.[0-9]+)?[A-Za-z]+\ [0-9]+(\.[0-9]+)?[A-Za-z]+$ ]]
}

# Test get_top_5_cpu function
@test "get_top_5_cpu function" {
  run bash -c 'source server-stats.sh > /dev/null && get_top_5_cpu > /dev/null && echo "$top_output"'
  [ "$status" -eq 0 ]
  [ $(echo "$output" | wc -l) -eq 5 ]
}

# Test display functions
@test "display_heading function" {
  run bash -c 'source server-stats.sh > /dev/null && display_heading'
  [ "$status" -eq 0 ]
  [[ "$output" == *"System Resources"* ]]
}

@test "display_cpu function" {
  run bash -c 'source server-stats.sh > /dev/null && display_cpu'
  [ "$status" -eq 0 ]
  [[ "$output" == *"CPU Used:"* ]]
  [[ "$output" == *"CPU Free:"* ]]
}

@test "display_memory function" {
  run bash -c 'source server-stats.sh > /dev/null && display_memory'
  [ "$status" -eq 0 ]
  [[ "$output" == *"Memory Used:"* ]]
  [[ "$output" == *"Memory Free:"* ]]
  [[ "$output" == *"Memory Available:"* ]]
}

@test "display_top_5_cpu function" {
  run bash -c 'source server-stats.sh > /dev/null && display_top_5_cpu'
  [ "$status" -eq 0 ]
  [[ "$output" == *"Top 5 CPU Processes"* ]]
  [ $(echo "$output" | grep -c "COMMAND") -eq 1 ]
}
