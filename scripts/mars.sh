#!/bin/bash

function get_os_name() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case $ID in
                ubuntu|debian)
                    echo "ubuntu"
                    ;;
                centos|rhel|fedora)
                    echo "redhat"
                    ;;
                *)
                    echo "linux"
                    ;;
            esac
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
    alias stash1='stash_data'
    alias show1='show_data'

function push_to_pastebin() {
    local text="$1"
    local api_dev_key="YOUR_PASTEBIN_API_KEY"
    local api_user_key="YOUR_PASTEBIN_USER_KEY"
    local response=$(curl -s -d "api_dev_key=$api_dev_key" -d "api_user_key=$api_user_key" -d "api_option=paste" -d "api_paste_code=$text" "https://pastebin.com/api/api_post.php")
    echo "$response"
}

function pop_from_pastebin() {
    local paste_key="$1"
    local response=$(curl -s "https://pastebin.com/raw/$paste_key")
    echo "$response"
}

function install_ubuntu_apps() {
    local apps=("vim" "ncdu")
    if [[ "$(get_os_name)" == "ubuntu" ]]; then
        sudo apt-get update -y
        sudo apt-get install -y "${apps[@]}"
    else
        echo "This function is only supported on Ubuntu systems."
    fi
}

function print_welcome_message() {
    echo "Welcome to Mars!"
    echo "Current OS: $(get_os_name)"    
}

BOOKMARK_FILE="$HOME/.bookmarks"

function bookmark_directory() {
    local bookmark_number="$1"
    if [[ "$bookmark_number" =~ ^[1-9]$ ]]; then
        local current_dir="$(pwd)"
        sed -i "/^BOOKMARK_$bookmark_number=/d" "$BOOKMARK_FILE" 2>/dev/null
        echo "BOOKMARK_$bookmark_number=\"$current_dir\"" >> "$BOOKMARK_FILE"
        echo "Bookmarked current directory as BOOKMARK_$bookmark_number"
    else
        echo "Invalid bookmark number. Please use a number between 1 and 9."
    fi
}

function go_to_bookmark() {
    local bookmark_number="$1"
    if [[ "$bookmark_number" =~ ^[1-9]$ ]]; then
        local bookmark_var="BOOKMARK_$bookmark_number"
        local bookmark_path=$(grep "^$bookmark_var=" "$BOOKMARK_FILE" | cut -d'=' -f2- | tr -d '"')
        if [ -n "$bookmark_path" ]; then
            cd "$bookmark_path" || echo "Failed to change directory to $bookmark_path"
        else
            echo "No bookmark set for number $bookmark_number"
        fi
    else
        echo "Invalid bookmark number. Please use a number between 1 and 9."
    fi
}
ENCRYPTION_KEY="your_secret_key"
ENCRYPTION_DIR="$HOME/.encrypted_data"

mkdir -p "$ENCRYPTION_DIR"

function stash_data() {
    local data="$1"
    local ref_id="$2"
    local encrypted_file="$ENCRYPTION_DIR/$ref_id.enc"

    echo "$data" | openssl enc -aes-256-cbc -salt -pass pass:"$ENCRYPTION_KEY" -out "$encrypted_file"
    echo "Data stashed with reference ID: $ref_id"
}

function show_data() {
    local ref_id="$1"
    local encrypted_file="$ENCRYPTION_DIR/$ref_id.enc"

    if [ -f "$encrypted_file" ]; then
        openssl enc -aes-256-cbc -d -salt -pass pass:"$ENCRYPTION_KEY" -in "$encrypted_file"
    else
        echo "No data found for reference ID: $ref_id"
    fi
}
    alias tt='run_ai_command'

    for i in {1..9}; do
        alias "save$i"="bookmark_directory $i"
        alias "go$i"="go_to_bookmark $i"
    done

    alias push1='push_to_pastebin'
    alias pop1='pop_from_pastebin'

}
set_aliases

#print_system_stats

# Example usage of the new function
#run_ai_command "What is the weather like on Mars?"
