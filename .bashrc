#!/bin/bash

# Source colors and utility files
if [ -f ~/.bashrc_colors ]; then
    source ~/.bashrc_colors
fi

if [ -f ~/.functions ]; then
    source ~/.functions
fi

# Welcome message
if [ -f ~/.hi ]; then
    source ~/.hi
fi

# Set prompt colors
LINE=$BGreen
NAME=$BRed
TEXT=$IWhite
LOAD=$Red

# OS detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    
    # macOS aliases
    alias ls='ls -G'
    alias ll='ls -lG'
    alias la='ls -laG'
else
    # Linux specific settings
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
fi

# Common aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Display system information
display_system_info() {
    echo ""
    echo "Welcome to the system!"
    echo ""
    echo "Today is $(date +"%A, %B %d, %Y")"
    echo "Current time: $(date +"%H:%M:%S")"
    echo ""
    echo "System Information:"
    echo "------------------"
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    
    # Different uptime command format for macOS vs Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Uptime: $(uptime | awk '{print $3,$4,$5}' | sed 's/,$//')"
        echo "Load Average: $(uptime | awk -F'[a-z]:' '{ print $2}')"
    else
        echo "Uptime: $(uptime -p)"
        echo "Load Average: $(uptime | awk -F'[a-z]:' '{ print $2}')"
    fi
    
    echo ""
    echo "Disk Usage:"
    echo "-----------"
    df -h / | awk 'NR==1; NR>1 {print}'
    echo ""
    echo "Memory Usage:"
    echo "------------"
    
    # Different free command format for macOS vs Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS doesn't have free command
        vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    else
        free -h | grep -v + | awk 'NR==1; NR>1 {print}'
    fi
    
    echo ""
    echo "Enjoy your session!"
    echo "------------------"
}

# Set custom prompt
PS1="\n$LINE┌──$NAME UnderMind$BGreen@$BCyan\h$RstColor $IYellow[\w]$RstColor \n$LINE└─> $TEXT"

# Run system info at login (can be commented out if not desired)
# display_system_info