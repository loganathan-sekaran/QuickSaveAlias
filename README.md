# QuickSaveAlias

Used to quickly add, remove, and change aliases and alias functions, which will be automatically persisted for future use.

**Note**: This feature will be applied only for the particular user where it is installed.

## Features

- **Quick alias management**: Add, remove, change, copy, or rename aliases with simple commands
- **Alias functions**: Create function-like aliases that accept arguments
- **Automatic persistence**: All changes are automatically saved
- **Cross-platform**: Works on both Linux (Bash) and macOS (Zsh)
- **Special character support**: Properly handles aliases with special characters in Zsh

## Alias Functions

Alias functions are single-line functions stored as aliases that can accept arguments.

Example:
```bash
# Create an alias function that takes a container name
adfn dex 'docker exec -it $1 /bin/bash'

# Use it
dex my-container  # Executes: docker exec -it my-container /bin/bash
```

## Installation

### Linux / Bash

#### Quick Install

**One-line install:**

```bash
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install.sh | bash
```

#### Manual Install

1. **Download or clone:**
   ```bash
   wget https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/quicksavealias.sh -O ~/.quicksavealias.sh
   chmod +x ~/.quicksavealias.sh
   ```

2. **Add to your `~/.bashrc`:**
   ```bash
   echo '[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install' >> ~/.bashrc
   ```

3. **Reload your shell:**
   ```bash
   source ~/.bashrc
   ```

### macOS / Zsh

#### Quick Install (Recommended)

**One-line install** (no git clone required):

```bash
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/master/install_mac.sh | zsh
```

Then close and reopen your terminal.

#### Manual Install

If you prefer to install manually or from a cloned repository:

1. **Clone the repository:**
   ```bash
   cd ~/git
   git clone https://github.com/loganathan001/QuickSaveAlias.git
   cd QuickSaveAlias
   ```

2. **Run the install script:**
   ```bash
   ./install_mac.sh
   ```
   
   Or install manually:
   ```bash
   cp quicksavealias_mac.sh ~/.quicksavealias.sh
   cp zsh_special_aliases.sh ~/.zsh_special_aliases.sh
   chmod +x ~/.quicksavealias.sh ~/.zsh_special_aliases.sh
   ```

3. **Add to your `~/.zshrc`:**
   ```zsh
   echo '' >> ~/.zshrc
   echo '[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install' >> ~/.zshrc
   echo '[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh' >> ~/.zshrc
   ```

4. **Reload your shell:**
   ```zsh
   source ~/.zshrc
   ```

**Note**: The macOS/Zsh version uses a special helper script (`~/.zsh_special_aliases.sh`) to handle aliases with special characters (like `-`, `...`, `1-9`, etc.) that require special quoting in Zsh.

## Quick Start

```bash
# Add an alias
adal ll 'ls -lah'

# Use it
ll

# Change an alias
chal ll 'ls -lh --color=auto'

# Remove an alias
rmal ll

# Copy an alias
cpal ll ll2

# Rename an alias
mval ll2 myls
```

## Usage Guide

### Utility Functions

| Command | Description | Example |
|---------|-------------|---------|
| `adal <name> <value>` | Add an alias and persist | `adal ll 'ls -lah'` |
| `rmal <name>` | Remove an alias and persist | `rmal ll` |
| `chal <name> <value>` | Change an alias and persist | `chal ll 'ls -lh'` |
| `cpal <old> <new>` | Copy an alias to a new name | `cpal ll ll2` |
| `mval <old> <new>` | Rename an alias | `mval ll myls` |
| `adfn <name> <function>` | Add an alias function | `adfn dex 'docker exec -it $1 /bin/bash'` |
| `rmfn <name>` | Remove an alias function | `rmfn dex` |
| `chfn <name> <function>` | Change an alias function | `chfn dex 'docker exec -it $1 sh'` |
| `cpfn <old> <new>` | Copy an alias function | `cpfn dex dexec` |
| `mvfn <old> <new>` | Rename an alias function | `mvfn dex dexec` |
| `alh` | Show usage help | `alh` |

### Built-in Aliases

| Alias | Description |
|-------|-------------|
| `al` | Shortcut for `alias` |
| `unal` | Shortcut for `unalias` |
| `lsal` | List all aliases |
| `sval` | Save all current aliases to file |
| `algrep <pattern>` | Search aliases by pattern |
| `lsfn` | List all alias functions |
| `fngrep <pattern>` | Search alias functions by pattern |
| `fixal` | Fix/repair broken aliases file (macOS/Zsh only) |

## Examples

### Working with Aliases

```bash
# Add a git shortcut
adal gs 'git status'

# Change it to include more info
chal gs 'git status -sb'

# Create a backup with a different name
cpal gs gst

# Rename it
mval gst gitstatus

# Remove it
rmal gitstatus
```

### Working with Alias Functions

```bash
# Create a function to search for files
adfn findf 'find . -name "*$1*"'
findf README  # Finds all files with README in the name

# Docker container exec function
adfn dex 'docker exec -it $1 /bin/bash'
dex my-container  # Opens bash in my-container

# Git commit with message function
adfn gcm 'git commit -m "$1"'
gcm "Initial commit"  # Commits with the message
```

### Managing Your Aliases

```bash
# List all aliases
lsal

# Search for docker-related aliases
algrep docker

# List all alias functions
lsfn

# Search functions
fngrep docker

# Manually save aliases (usually automatic)
sval
```

## Import Existing Aliases

If you're migrating from Bash or have a backup of aliases:

```bash
cd ~/git/QuickSaveAlias
./import_aliases.sh ~/path/to/your/.bash-aliases

# Or import from any backup file
./import_aliases.sh my_aliases_bkup/.bash-aliases-dev
```

See [IMPORT_GUIDE.md](IMPORT_GUIDE.md) for detailed import instructions.

## File Locations

### Linux / Bash
- Main script: `~/.quicksavealias.sh`
- Aliases file: `~/.bash-aliases`

### macOS / Zsh
- Main script: `~/.quicksavealias.sh`
- Aliases file: `~/.zsh-aliases`
- Special aliases helper: `~/.zsh_special_aliases.sh`

## Uninstalling

1. Remove the installation lines from your `~/.bashrc` (Linux) or `~/.zshrc` (macOS):
   ```bash
   # Remove these lines:
   [ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
   [ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh  # macOS only
   ```

2. (Optional) Remove the aliases files:
   ```bash
   rm ~/.quicksavealias.sh
   rm ~/.bash-aliases  # Linux
   rm ~/.zsh-aliases ~/.zsh_special_aliases.sh  # macOS
   ```

3. Reload your shell:
   ```bash
   source ~/.bashrc  # Linux
   source ~/.zshrc   # macOS
   ```

**Note**: To keep your created aliases for future installations, back up `~/.bash-aliases` (Linux) or `~/.zsh-aliases` (macOS) before removing.

## Troubleshooting (macOS/Zsh)

If you encounter issues after migrating from Linux/Bash or after an upgrade:

### Problem: Terminal shows errors when opening

Run the repair script:
```zsh
cd ~/git/QuickSaveAlias
./QUICK_FIX.sh
source ~/.zshrc
```

### Problem: Aliases not loading or parsing errors

```zsh
# Run the fixal utility to repair your aliases file
fixal
source ~/.zshrc
```

### Problem: Special character aliases (like -, ..., 1-9) not working

```zsh
# Re-run the install to update the special aliases helper
cd ~/git/QuickSaveAlias
./QUICK_FIX.sh
source ~/.zshrc
```

### Problem: Need to import aliases from backup

```zsh
cd ~/git/QuickSaveAlias
./import_aliases.sh path/to/your/backup-aliases
source ~/.zshrc
```

See [IMPORT_GUIDE.md](IMPORT_GUIDE.md) for detailed import instructions.

### Fresh Install (if repair doesn't work)

```zsh
# Backup your current aliases
cp ~/.zsh-aliases ~/.zsh-aliases.backup

# Remove old installation
rm ~/.quicksavealias.sh ~/.zsh_special_aliases.sh

# Reinstall
cd ~/git/QuickSaveAlias
cp quicksavealias_mac.sh ~/.quicksavealias.sh
cp zsh_special_aliases.sh ~/.zsh_special_aliases.sh
chmod +x ~/.quicksavealias.sh ~/.zsh_special_aliases.sh

# Add to .zshrc if not already there
echo '[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install' >> ~/.zshrc
echo '[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh' >> ~/.zshrc

# Import your aliases back
./import_aliases.sh ~/.zsh-aliases.backup

# Reload
source ~/.zshrc
```

## Guides

- **[INSTALL_CURL.md](INSTALL_CURL.md)** - One-line curl installation guide ⭐
- **[IMPORT_GUIDE.md](IMPORT_GUIDE.md)** - How to import aliases from backup files
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Complete migration guide from Linux/Bash to macOS/Zsh
- **[INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)** - Complete installation guide
- **[FIX_NOW.md](FIX_NOW.md)** - Quick fixes for common issues

## Why QuickSaveAlias?

- **Persistence**: Regular aliases are lost when you close your terminal
- **Easy Management**: Add, change, remove aliases without editing files manually
- **Safety**: Prevents overwriting existing aliases accidentally
- **Functions with Arguments**: Create reusable command templates
- **Cross-Platform**: Same commands work on Linux and macOS
- **Automatic Backup**: Changes are immediately saved

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Loganathan.S - [github.com/loganathan001](https://github.com/loganathan001)

## License

This project is open source and available under the MIT License.
