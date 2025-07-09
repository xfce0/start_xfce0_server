#!/bin/bash
# XFCE0 Shell Prompt Configuration
# Based on the user's preferred style

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
Reset='\[\e[0m\]'       # Text Reset

# Regular Colors (Subtle, not bright)
Black='\[\e[0;30m\]'    # Black
Red='\[\e[0;31m\]'      # Red
Green='\[\e[0;32m\]'    # Green
Yellow='\[\e[0;33m\]'   # Yellow
Blue='\[\e[0;34m\]'     # Blue
Purple='\[\e[0;35m\]'   # Purple
Cyan='\[\e[0;36m\]'     # Cyan
White='\[\e[0;37m\]'    # White

# Bold
BBlack='\[\e[1;30m\]'   # Black
BRed='\[\e[1;31m\]'     # Red
BGreen='\[\e[1;32m\]'   # Green
BYellow='\[\e[1;33m\]'  # Yellow
BBlue='\[\e[1;34m\]'    # Blue
BPurple='\[\e[1;35m\]'  # Purple
BCyan='\[\e[1;36m\]'    # Cyan
BWhite='\[\e[1;37m\]'   # White

# High Intensity
IBlack='\[\e[0;90m\]'   # Black
IRed='\[\e[0;91m\]'     # Red
IGreen='\[\e[0;92m\]'   # Green
IYellow='\[\e[0;93m\]'  # Yellow
IBlue='\[\e[0;94m\]'    # Blue
IPurple='\[\e[0;95m\]'  # Purple
ICyan='\[\e[0;96m\]'    # Cyan
IWhite='\[\e[0;97m\]'   # White

# Bold High Intensity
BIBlack='\[\e[1;90m\]'  # Black
BIRed='\[\e[1;91m\]'    # Red
BIGreen='\[\e[1;92m\]'  # Green
BIYellow='\[\e[1;93m\]' # Yellow
BIBlue='\[\e[1;94m\]'   # Blue
BIPurple='\[\e[1;95m\]' # Purple
BICyan='\[\e[1;96m\]'   # Cyan
BIWhite='\[\e[1;97m\]'  # White

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
      
      echo " ${BPurple}git:(${branch}${status:+" $status"})${Reset}"
    fi
  fi
}

# ================== Load Average Function ===================
load_average() {
  # Load average
  if [ -f /proc/loadavg ]; then
    set -- `cat /proc/loadavg`
    
    five=$1
    let int_five=`echo $five | cut -d '.' -f1`
    
    ten=$2
    let int_ten=`echo $ten | cut -d '.' -f1`
    
    fifteen=$3
    let int_fifteen=`echo $fifteen | cut -d '.' -f1`
    
    # Threshold for critical load
    let CRIT_LOAD=2
    
    local load_str=""
    
    # FIVE
    if [ $int_five -gt $CRIT_LOAD ]; then
      load_str+="${Red}"
    else
      load_str+="${Yellow}"
    fi
    load_str+="$five "
    
    # TEN
    if [ $int_ten -gt $CRIT_LOAD ]; then
      load_str+="${Red}"
    else
      load_str+="${Yellow}"
    fi
    load_str+="$ten "
    
    # FIFTEEN
    if [ $int_fifteen -gt $CRIT_LOAD ]; then
      load_str+="${Red}"
    else
      load_str+="${Yellow}"
    fi
    load_str+="$fifteen${Reset}"
    
    echo " $load_str"
  fi
}

# ================== Prompt Setup ===================
if [ "$SHELL_TYPE" = "zsh" ]; then
  # ZSH Prompt
  setopt PROMPT_SUBST
  
  # Parse current working directory to show full path
  prompt_dir() {
    echo "%{$Blue%}%~%{$Reset%}"
  }
  
  # Function to show exit status of last command
  prompt_status() {
    echo "%(?:%{$Green%}➜:%{$Red%}➜)"
  }
  
  # Setup git integration for zsh
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git*' formats " ${BPurple}git:(%b)${Reset}"
  precmd() { vcs_info }
  
  # Main prompt - XFCE0 style
  PROMPT='%{$BBlue%}┌──[%{$BRed%}xfce0%{$BGreen%}@%{$BCyan%}%m%{$Reset%}]-%{$BIYellow%}[%~]%{$Reset%}${vcs_info_msg_0_}
%{$BBlue%}└─> %{$IWhite%}'
  
  # Right prompt with timestamp
  RPROMPT='%{$Cyan%}[%D{%H:%M:%S}]%{$Reset%}'
  
else
  # Bash Prompt
  
  # Show full path in prompt (requested by user)
  PS1_DIR='\[${Blue}\]\w\[${Reset}\]'
  
  # Set line color for XFCE0 style
  LINE=$BGreen
  
  # Name for the prompt
  NAME=$BRed
  
  # Text color
  TEXT=$IWhite
  
  # Define the main prompt style
  PS1="\n$LINE┌──[$NAME xfce0$BGreen@$BCyan\h$Reset] $BIYellow[\w]$Reset\$(git_status) \n$LINE└─> $TEXT"
  
  # Add timestamp if terminal supports it
  if [[ "$TERM" != "dumb" && "$TERM" != "unknown" ]]; then
    PS1="\n$LINE┌──[$NAME xfce0$BGreen@$BCyan\h$Reset] $BIYellow[\w]$Reset\$(git_status)$Cyan [\t]$Reset\n$LINE└─> $TEXT"
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
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS specific
  alias ls='ls -G'
  alias ll='ls -alFG'
  alias la='ls -AG'
else
  # Linux specific
  alias ls='ls --color=auto'
  alias ll='ls -alF --color=auto'
  alias la='ls -A --color=auto'
fi

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