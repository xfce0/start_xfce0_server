#!/bin/bash
# Shell Prompt Configuration
# Created by Claude

# ================== Detect shell type ===================
if [[ -n "$ZSH_VERSION" ]]; then
  SHELL_TYPE="zsh"
elif [[ -n "$BASH_VERSION" ]]; then
  SHELL_TYPE="bash"
else
  SHELL_TYPE="sh"
fi

# ================== Colors ===================
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors (Subtle, not bright)
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold (but still subtle)
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# ================== Git Status Function ===================
git_status() {
  if command -v git >/dev/null 2>&1; then
    # Check if we're in a git repo
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)
      local git_status=$(git status --porcelain 2>/dev/null)
      
      # Status indicators
      local status=""
      [[ -n $(echo "$git_status" | grep -e "^ M" -e "^MM") ]] && status+="*" # Modified
      [[ -n $(echo "$git_status" | grep "^??") ]] && status+="+" # Untracked
      [[ -n $(echo "$git_status" | grep "^A") ]] && status+="^" # Added
      [[ -n $(echo "$git_status" | grep "^ D" -e "^D") ]] && status+="-" # Deleted
      
      echo " ${BPurple}git:(${branch}${status:+" $status"})${Color_Off}"
    fi
  fi
}

# ================== Prompt Setup ===================
if [ "$SHELL_TYPE" = "zsh" ]; then
  # ZSH Prompt
  setopt PROMPT_SUBST
  
  # Parse current working directory to show full path
  prompt_dir() {
    echo "%{$Blue%}%~%{$Color_Off%}"
  }
  
  # Function to show exit status of last command
  prompt_status() {
    echo "%(?:%{$Green%}➜:%{$Red%}➜)"
  }
  
  # Setup git integration for zsh
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git*' formats " ${BPurple}git:(%b)${Color_Off}"
  precmd() { vcs_info }
  
  # Main prompt
  PROMPT='$(prompt_status) $(prompt_dir)${vcs_info_msg_0_} %{$Yellow%}»%{$Color_Off%} '
  
  # Right prompt with timestamp
  RPROMPT='%{$Cyan%}[%D{%H:%M:%S}]%{$Color_Off%}'
  
else
  # Bash Prompt
  
  # Show full path in prompt (requested by user)
  PS1_DIR='\[${Blue}\]\w\[${Color_Off}\]'
  
  # Setup the prompt
  PS1='\[${Green}\]\u@\h\[${Color_Off}\]:\[${Blue}\]\w\[${Color_Off}\]$(git_status)\[${Yellow}\] »\[${Color_Off}\] '
  
  # Add timestamp to prompt if terminal supports it
  if [[ "$TERM" != "dumb" && "$TERM" != "unknown" ]]; then
    PS1='\[${Cyan}\][\t]\[${Color_Off}\] '$PS1
  fi
  
  export PS1
fi

# ================== Aliases ===================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directories
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Common commands
alias c='clear'
alias h='history'
alias j='jobs -l'
alias md='mkdir -p'
alias rd='rmdir'

# Safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Show current directory disk usage
alias space='du -sh ./* | sort -h'

# System info
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'

# Calendar with week numbers
alias cal='cal -w'

# ================== Terminal Settings ===================
# Set window title
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;
screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

# Better history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups

# Append to history, don't overwrite
if [ "$SHELL_TYPE" = "bash" ]; then
  shopt -s histappend
fi

# ================== Functions ===================
# Make directory and change into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive types
extract() {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name
ff() { find . -type f -name "$1"; }

# Find directory by name
fd() { find . -type d -name "$1"; }

# Search for string in files
search() {
  grep -r "$1" .
}

# Show the welcome message on login
if [ -f /etc/motd ]; then
  cat /etc/motd
elif [ -f "$HOME/.termux/motd.txt" ]; then
  cat "$HOME/.termux/motd.txt"
fi