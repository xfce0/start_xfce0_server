#!/bin/bash

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Start tmux by default if it's installed, we're not already in tmux, and this is an interactive shell
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ]; then
    # Start new session or attach to existing one
    tmux attach -t default || tmux new -s default
fi