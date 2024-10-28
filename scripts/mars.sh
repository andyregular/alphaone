#!/bin/bash

function print_welcome_message() {
    echo "Welcome to Mars!"
}

function print_system_stats() {
    echo "System Stats:"
    echo "Free Memory:"
    free -h
}

print_welcome_message
print_system_stats
