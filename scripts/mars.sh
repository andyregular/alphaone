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
function bookmark_directory() {
    local bookmark_number="$1"
    if [[ "$bookmark_number" =~ ^[1-9]$ ]]; then
        eval "export BOOKMARK_$bookmark_number=\"$(pwd)\""
        echo "Bookmarked current directory as BOOKMARK_$bookmark_number"
    else
        echo "Invalid bookmark number. Please use a number between 1 and 9."
    fi
}

function go_to_bookmark() {
    local bookmark_number="$1"
    if [[ "$bookmark_number" =~ ^[1-9]$ ]]; then
        local bookmark_var="BOOKMARK_$bookmark_number"
        if [ -n "${!bookmark_var}" ]; then
            cd "${!bookmark_var}" || echo "Failed to change directory to ${!bookmark_var}"
        else
            echo "No bookmark set for number $bookmark_number"
        fi
    else
        echo "Invalid bookmark number. Please use a number between 1 and 9."
    fi
}
    alias tt='run_ai_command'
    
    for i in {1..9}; do
        alias "save$i"="bookmark_directory $i"
    done
}

#set_aliases

#print_system_stats

# Example usage of the new function
#run_ai_command "What is the weather like on Mars?"
