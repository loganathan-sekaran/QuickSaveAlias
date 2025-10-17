# Migration Guide: Linux/Bash to macOS/Zsh

This guide helps you migrate QuickSaveAlias from Linux (Bash) to macOS (Zsh).

## Important: Separate Implementations

QuickSaveAlias maintains **two separate implementations**:

- **Linux/Bash**: Uses `quicksavealias.sh` and `.bash-aliases`
- **macOS/Zsh**: Uses `quicksavealias_mac.sh` and `.zsh-aliases`

Both versions are fully compatible and maintained separately, so Linux functionality is never affected by macOS changes.

## Quick Fix for Terminal Errors

If you're seeing errors when opening a new terminal after migrating to macOS:

```zsh
cd ~/git/QuickSaveAlias  # or wherever you cloned the repo
./repair_mac.sh
source ~/.zshrc
```

That's it! The repair script will:
1. Backup your existing files
2. Install the latest macOS version
3. Fix your `.zshrc` configuration
4. Repair your aliases file format
5. Configure special character aliases properly

## Understanding the Difference

### Linux/Bash Version
- Uses `~/.bash-aliases` file
- All aliases stored in one file
- Works with Bash shell syntax
- Sourced directly from `.bashrc`

### macOS/Zsh Version
- Uses `~/.zsh-aliases` file for regular aliases
- Uses `~/.zsh_special_aliases.sh` for special character aliases (like `-`, `...`, `1-9`)
- Works with Zsh shell syntax
- Two-file system to avoid Zsh parsing issues
- Sourced from `.zshrc`

## Why Two Files for macOS?

Zsh has stricter parsing rules than Bash. Aliases with special characters (like `-`, `.`, or starting with numbers) can cause parsing errors when loaded directly from a file. The solution:

1. **Regular aliases** → `~/.zsh-aliases` (git, ls, cd shortcuts, etc.)
2. **Special character aliases** → `~/.zsh_special_aliases.sh` (-, ..., 1-9, etc.)

The system automatically:
- Detects which aliases need special handling
- Routes them to the appropriate file
- Keeps everything synchronized with the `syncSpecialAliases` function

## Manual Migration Steps

If you prefer to understand what's happening:

### Step 1: Backup Your Aliases
```zsh
# If you have bash aliases from Linux
cp ~/.bash-aliases ~/.bash-aliases.backup

# If you already have zsh aliases
cp ~/.zsh-aliases ~/.zsh-aliases.backup
```

### Step 2: Remove Old Installation (if any)
```zsh
rm ~/.quicksavealias.sh
rm ~/.zsh_special_aliases.sh
```

### Step 3: Install macOS Version
```zsh
cd ~/git/QuickSaveAlias
cp quicksavealias_mac.sh ~/.quicksavealias.sh
cp zsh_special_aliases.sh ~/.zsh_special_aliases.sh
chmod +x ~/.quicksavealias.sh ~/.zsh_special_aliases.sh
```

### Step 4: Update .zshrc
Add these lines to `~/.zshrc`:

```zsh
# Install QuickSaveAlias for the session
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install

# Load all aliases including special character aliases
[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh
```

Remove any old direct sourcing:
```zsh
# Remove this if it exists:
# source ~/.zsh-aliases
```

### Step 5: Convert Bash Aliases (if migrating from Linux)
If you have a `.bash-aliases` file from Linux:

```zsh
# Use the import tool to convert them
cd ~/git/QuickSaveAlias
./import_aliases.sh ~/.bash-aliases.backup
```

### Step 6: Apply Changes
```zsh
source ~/.zshrc
```

## Common Issues and Solutions

### Issue: "command not found" errors for aliases
**Solution**: Run `fixal` to repair the aliases file format
```zsh
source ~/.quicksavealias.sh -install
fixal
source ~/.zshrc
```

### Issue: Special character aliases not working
**Solution**: Sync special character aliases
```zsh
source ~/.quicksavealias.sh -install
syncSpecialAliases
source ~/.zsh_special_aliases.sh
```

### Issue: Duplicate aliases loading
**Solution**: Check that `.zshrc` doesn't directly source `.zsh-aliases`
```zsh
# Only these two lines should be in .zshrc:
[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install
[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh
```

### Issue: Aliases file has wrong format
**Symptom**: Lines like `g=git` instead of `alias g=git`

**Solution**: The aliases file should have `alias` prefix. Run:
```zsh
fixal
```

This will:
- Backup your current file to `.zsh-aliases.bak`
- Add proper `alias` prefixes
- Separate special character aliases
- Sync everything properly

## Verifying Your Installation

After installation, test that everything works:

```zsh
# Check that the commands exist
which adal    # Should show: adal function
which sval    # Should show: sval function
which fixal   # Should show: fixal function

# Test adding an alias
adal test 'echo "It works!"'
test          # Should print: It works!

# Test special character aliases
-             # Should return to previous directory
...           # Should go up two directories

# Save and reload
sval
source ~/.zsh_special_aliases.sh
```

## Key Utilities

- `adal <name> <value>` - Add an alias
- `chal <name> <value>` - Change an alias
- `rmal <name>` - Remove an alias
- `sval` - Save all aliases (auto-syncs special ones)
- `fixal` - Fix broken aliases file format
- `syncSpecialAliases` - Manually sync special character aliases
- `alh` - Show help

## Getting Help

If you continue to have issues:

1. Check the main [README.md](README.md)
2. Run the repair script: `./repair_mac.sh`
3. Look at the [Troubleshooting section](README.md#troubleshooting-macoszsh) in README
4. Check your backups in `~/.zsh-aliases.backup`

## Important Files

- `~/.quicksavealias.sh` - Main script (macOS version)
- `~/.zsh-aliases` - Regular aliases storage
- `~/.zsh_special_aliases.sh` - Special character aliases and loader
- `~/.zshrc` - Zsh configuration (loads everything)

## Reverting to Linux/Bash

If you need to go back to Linux, the Bash version (`quicksavealias.sh`) is completely separate and unchanged. Just follow the original Linux installation instructions in the README.

