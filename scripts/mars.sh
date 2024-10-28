#!/bin/bash

function print_welcome_message() {
    echo "Welcome to Mars!"
}

function print_system_stats() {
    echo "System Stats:"
    echo "Free Memory:"
    free -h
}

function run_ai_command() {
    local user_input="$*"
    tgpt --provider duckduckgo "$user_input"
}
print_system_stats
