# Enhanced Terminal Configuration Pack for Linux and macOS

A comprehensive terminal configuration pack for Linux and macOS that includes customizations for Vim, Tmux, SSH, and shell prompts. The configuration provides a practical and visually pleasing terminal experience with a custom SSH welcome banner.

## Features

- **One-command installation**: Set up all configurations with a single command
- **Cross-platform support**: Works on Linux, macOS, and Termux
- **Full path in prompt**: Shows the complete path in your terminal prompt
- **Custom SSH welcome banner**: Displays a stylish @xfce0 banner when connecting via SSH
- **Tmux session management**: Enhanced Tmux configuration for better productivity
- **Vim optimizations**: Practical Vim settings for efficient editing
- **SSH timeout prevention**: Configured with optimized ClientAliveInterval (30s) and ClientAliveCountMax (3) to keep SSH sessions alive
- **Termux enhancements**: Scrolling and usability improvements for Termux
- **Subtle color scheme**: Non-bright, eye-friendly colors

## Quick Start

1. Clone this repository:
   ```
   git clone https://github.com/xfce0/start_xfce0_server.git
   cd start_xfce0_server
   ```

2. Make the install script executable:
   ```
   chmod +x install.sh
   ```

3. Run the installer:
   ```
   ./install.sh
   ```

4. Restart your terminal or run `source ~/.bashrc` (or `~/.zshrc` if using zsh) to apply changes

## Detailed Configuration Overview

### Vim Configuration

The included `.vimrc` provides:

- **Syntax highlighting**: With a subtle color scheme
- **Enhanced line numbering**: Consistent width for line numbers with better visual styling
- **Improved navigation**: Enhanced split management
- **Smart indentation**: Proper indentation based on file type
- **Search improvements**: Incremental search with highlighting
- **Visual aids**: Highlight current line, matching brackets
- **File browsing**: Improved netrw settings

#### Vim Commands

| Command | Description |
|---------|-------------|
| `<Space>w` | Save file |
| `<Space>q` | Quit Vim |
| `<Space>x` | Save and quit |
| `<Ctrl>-h/j/k/l` | Navigate between splits |
| `<Space>c` | Clear search highlighting |
| `<Space>n` | Toggle line numbers |
| `<Space>r` | Toggle relative line numbers |
| `<Space>b` | List and switch buffers |

### Tmux Configuration

The `.tmux.conf` provides:

- **Custom prefix**: Changed from `Ctrl+b` to `Ctrl+a` for easier reach
- **Intuitive splits**: Use `|` for vertical and `-` for horizontal splits
- **Session management**: Easy session creation and navigation
- **Status bar**: Informative but subtle status bar
- **Enhanced mouse mode**: Full mouse support with improved scrolling and selection
- **Copy-paste integration**: Better handling of selection and copy-paste operations
- **Vi-mode**: Vi-like copy mode with mouse compatibility

#### Tmux Commands

| Command | Description |
|---------|-------------|
| `Ctrl+a r` | Reload tmux config |
| `Ctrl+a \|` | Split window vertically |
| `Ctrl+a -` | Split window horizontally |
| `Ctrl+a h/j/k/l` | Navigate between panes |
| `Ctrl+a H/J/K/L` | Resize panes |
| `Ctrl+a N` | Create new window |
| `Ctrl+a S` | Swap panes |
| `Ctrl+a s` | Choose session |
| `Ctrl+a X` | Kill session |
| `Ctrl+a y` | Toggle synchronize-panes |
| `Ctrl+a b` | Toggle status bar |

### SSH Configuration

The SSH configuration:

- **Prevents timeouts**: Keeps connections alive with keepalive packets
- **Enhances security**: Uses strong encryption algorithms
- **Optimizes performance**: Enables compression and connection sharing
- **Welcomes users**: Custom banner when connecting

### Shell Prompt Configuration

The shell prompt:

- **Shows full path**: Displays complete current directory path
- **Git integration**: Shows git branch and status when in a repository
- **Timestamps**: Includes time information
- **XFCE0 styling for Linux**: Special XFCE0-branded prompt for Linux systems
- **Load average monitoring**: Shows system load with color-coded indicators
- **Command history**: Enhanced history with larger size and duplicates prevention
- **Useful aliases**: Common shortcuts for frequently used commands
- **Helper functions**: Utility functions like `extract` and `mkcd`

#### Shell Commands and Aliases

| Command | Description |
|---------|-------------|
| `..`, `...`, etc. | Navigate up directories |
| `ll` | List files with details |
| `c` | Clear screen |
| `h` | Show history |
| `space` | Show disk usage in current directory |
| `mkcd directory` | Create and change to directory |
| `extract file` | Extract various archive types |
| `ff pattern` | Find file by name |
| `fd pattern` | Find directory by name |
| `search text` | Search for text in files |

### Termux Configuration

The Termux settings:

- **Scrollback**: Enables scrolling through terminal output
- **Extra keys**: Adds useful keys row
- **Color scheme**: Subtle, eye-friendly colors
- **Keyboard shortcuts**: Enhanced session management

## Customization

After installation, you can further customize the configurations:

- Vim: Edit `~/.vimrc`
- Tmux: Edit `~/.tmux.conf`
- SSH: Edit `~/.ssh/config`
- Shell: Edit `~/.bashrc` or `~/.zshrc`
- Termux: Edit `~/.termux/termux.properties`

## Backing Up Your Previous Settings

The installer automatically backs up your existing configurations to `~/.terminal_backups/` with a timestamp.

## Troubleshooting

If you encounter issues:

1. Check the backups in `~/.terminal_backups/` to restore previous configurations
2. Ensure proper permissions for SSH configuration files
3. For Termux, run `termux-reload-settings` after making changes

## License

MIT License - Feel free to use and modify as needed.

## Credits

Created by Claude AI
