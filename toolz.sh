#!/bin/bash
RED="\033[3;31m"
GREEN="\033[3;32m"
YELLOW="\033[3;33m"
BLUE="\033[3;34m"
NC="\033[0m" # No Color

echo -e "${BLUE}Bash scripting Project${NC}"
echo -e "${BLUE}Description:${YELLOW}Multi system admin tools${NC}"
echo -e "${BlUE}Author:${YELLOW}Iraqi Sami${NC}"
echo -e "${BLUE}Course:${YELLOW}BIU DevSecOps 19${NC}"
echo -e "${BLUE}Lecturer:${YELLOW}Yuval Shaul${NC}"
echo -e "${BLUE}Date:${YELLOW}06/05/2025${NC}"



# Toolz Script: A multi-functional utility script

# Define color codes for better readability
RED="\033[3;31m"
GREEN="\033[3;32m"
YELLOW="\033[3;33m"
BLUE="\033[3;34m"
NC="\033[0m" # No Color

# Load persistent configuration options
CONFIG_FILE="$HOME/.toolz_config"
if [ -f $CONFIG_FILE ]; then
    source $CONFIG_FILE
else
    echo "# Toolz Configuration File" > $CONFIG_FILE
fi

# Function to save configuration
function save_config() {
    echo "$1=$2" >> $CONFIG_FILE
}

# Function: Find Helper
function find_helper() {
    echo -e "${BLUE}Welcome to the Find Helper!${NC}"

    # Step 1: Specify the search location
    echo "Step 1: Specify the search location (default is current directory):"
    read -p "Enter the directory path: " search_location
    search_location=${search_location:-${DEFAULT_SEARCH_LOCATION:-.}}
    save_config "DEFAULT_SEARCH_LOCATION" "$search_location"

    # Step 2: Specify the filename pattern
    echo "Step 2: Specify the filename pattern (e.g., *.txt, *.sh, default is *):"
    read -p "Enter the filename pattern: " filename_pattern
    filename_pattern=${filename_pattern:-*}

    # Step 3: Additional find options
    echo "Step 3: Specify additional find options (e.g., -type f, -size +1M, leave blank for none):"
    read -p "Enter additional options: " additional_options

    # Step 4: Confirm and execute the find command
    echo -e "${YELLOW}You are about to run the following command:${NC}"
    echo "find $search_location -name \"$filename_pattern\" $additional_options"
    read -p "Do you want to proceed? (y/n): " confirm

    if [ $confirm == "y" || $confirm == "Y" ]; then
        find $search_location -name "$filename_pattern" $additional_options
    else
        echo -e "${RED}Command canceled.${NC}"
    fi
}

# Function: System Information
function system_info() {
    echo "System Information:"
    echo "-------------------"
    echo "Available Memory:"
    free -h
    echo "\nNumber of Running Processes:"
    ps -e --no-headers | wc -l
    echo "\nDisk Usage Statistics:"
    df -h
}

# Function: Process Management
function process_management() {
    echo -e "${BLUE}Process Management:${NC}"
    echo "-------------------"
    echo "Choose sorting option:"
    echo "1. CPU Usage"
    echo "2. Memory Usage"
    echo "3. Runtime"
    read -p "Enter your choice (1/2/3): " sort_option

    case $sort_option in
        1)
            ps -eo pid,comm,%cpu,%mem,etime --sort=-%cpu | head -n 15
            ;;
        2)
            ps -eo pid,comm,%cpu,%mem,etime --sort=-%mem | head -n 15
            ;;
        3)
            ps -eo pid,comm,%cpu,%mem,etime --sort=etime | head -n 15
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            return
            ;;
    esac

    read -p "Enter PID to kill (or press Enter to skip): " pid_to_kill
    if [ -n $pid_to_kill ]; then
        if kill $pid_to_kill; then
            echo -e "${GREEN}Process $pid_to_kill killed.${NC}"
        else
            echo -e "${RED}Failed to kill process $pid_to_kill.${NC}"
        fi
    fi
}

# Function: User Management
function user_management() {
    echo "User Management:"
    echo "----------------"
    echo "1. Show currently logged-in users and their activities"
    echo "2. Display user account information"
    read -p "Enter your choice (1/2): " user_option

    case $user_option in
        1)
            w
            ;;
        2)
            read -p "Enter username: " username
            id $username
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function: Help System
function display_help() {
    echo -e "${BLUE}Toolz Script Help${NC}"
    echo "-----------------"
    echo "Usage: $0 [option]"
    echo "Options:"
    echo -e "  ${YELLOW}-f${NC}    Find Helper: Interactive helper for the 'find' command"
    echo -e "  ${YELLOW}-s${NC}    System Information: Display system metrics"
    echo -e "  ${YELLOW}-p${NC}    Process Management: Manage processes interactively"
    echo -e "  ${YELLOW}-u${NC}    User Management: Manage user accounts and sessions"
    echo -e "  ${YELLOW}-h${NC}    Help: Display this help message"
    echo "Examples:"
    echo "  $0 -f"
    echo "  $0 -s"
    echo "  $0 -p"
    echo "  $0 -u"
    echo "  $0 -h"
}

# Main script logic
if [ $# -eq 0 ]; then
    display_help
    exit 1
fi

while getopts ":fspuh" opt; do
    case $opt in
        f)
            find_helper
            ;;
        s)
            system_info
            ;;
        p)
            process_management
            ;;
        u)
            user_management
            ;;
        h)
            display_help
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            display_help
            exit 1
            ;;
    esac
done
