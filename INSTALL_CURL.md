# QuickSaveAlias - One-Line Installation

## 🚀 Quick Install (No Git Clone Required)

### macOS / Zsh

```bash
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install_mac.sh | zsh
```

Then **close and reopen your terminal**.

### Linux / Bash

```bash
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install.sh | bash
```

Then run: `source ~/.bashrc`

---

## ✅ What Gets Installed

### macOS
- `~/.quicksavealias.sh` - Main script
- `~/.zsh_special_aliases.sh` - Special character handler
- `~/.zshrc` - Auto-configured
- `~/.zsh-aliases` - Your aliases storage

### Linux
- `~/.quicksavealias.sh` - Main script
- `~/.bashrc` - Auto-configured
- `~/.bash-aliases` - Your aliases storage

---

## 📝 After Installation

### Test It Works
```bash
# Show help
alh

# Create a test alias
adal test 'echo Hello from QuickSaveAlias!'

# Run it
test

# List all aliases
lsal
```

### Import Existing Aliases (Optional)

If you have old aliases to import:

**macOS:**
```bash
cd ~/git/QuickSaveAlias
./import_aliases.sh ~/path/to/old-aliases
```

**Linux:**
```bash
cd ~/git/QuickSaveAlias
./import_bash_aliases.sh ~/path/to/old-aliases
```

---

## 🔧 Installation Script Features

### What It Does
- ✅ Downloads required files from GitHub
- ✅ Backs up existing installations
- ✅ Installs to home directory
- ✅ Auto-configures shell RC files
- ✅ Creates initial aliases file
- ✅ Sets correct permissions
- ✅ Works without git clone

### Safe to Re-run
- Creates timestamped backups
- Doesn't duplicate config entries
- Preserves existing aliases

---

## 📖 URLs

Replace `loganathan001` with your GitHub username:

**macOS Install:**
```
https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install_mac.sh
```

**Linux Install:**
```
https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install.sh
```

**Main Script (macOS):**
```
https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/quicksavealias_mac.sh
```

**Main Script (Linux):**
```
https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/quicksavealias.sh
```

**Special Aliases Helper (macOS):**
```
https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/zsh_special_aliases.sh
```

---

## 🛠️ Manual Installation

If you prefer to install manually or the curl method doesn't work:

### macOS
```bash
# Download files
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/quicksavealias_mac.sh -o ~/.quicksavealias.sh
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/zsh_special_aliases.sh -o ~/.zsh_special_aliases.sh
chmod +x ~/.quicksavealias.sh ~/.zsh_special_aliases.sh

# Configure .zshrc
echo '' >> ~/.zshrc
echo '[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install' >> ~/.zshrc
echo '[ -f ~/.zsh_special_aliases.sh ] && source ~/.zsh_special_aliases.sh' >> ~/.zshrc

# Reload
source ~/.zshrc
```

### Linux
```bash
# Download file
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/quicksavealias.sh -o ~/.quicksavealias.sh
chmod +x ~/.quicksavealias.sh

# Configure .bashrc
echo '[ -e ~/.quicksavealias.sh ] && source ~/.quicksavealias.sh -install' >> ~/.bashrc

# Reload
source ~/.bashrc
```

---

## 🆘 Troubleshooting

### Curl command fails

**Check 1:** Verify the GitHub URL is correct
```bash
# Test if file exists
curl -I https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install_mac.sh
```

**Check 2:** Try with wget instead
```bash
wget -O - https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install_mac.sh | zsh
```

**Check 3:** Clone and install manually
```bash
git clone https://github.com/loganathan001/QuickSaveAlias.git
cd QuickSaveAlias
./install_mac.sh  # or ./install.sh for Linux
```

### Installation completes but commands don't work

**Solution:** Close and reopen your terminal (or source RC file)
```bash
source ~/.zshrc   # macOS
source ~/.bashrc  # Linux
```

### Already installed, want to reinstall

**Solution:** The script automatically backs up and reinstalls
```bash
# Just run the install again
curl -fsSL https://raw.githubusercontent.com/loganathan001/QuickSaveAlias/main/install_mac.sh | zsh
```

Your old files will be backed up as:
- `~/.quicksavealias.sh.backup-YYYYMMDD-HHMMSS`

---

## 🎉 Success!

Once installed, you have full access to QuickSaveAlias:

```bash
# Add aliases
adal gs 'git status'
adal gp 'git push'
adal gpl 'git pull'

# Add alias functions
adfn dex 'docker exec -it $1 /bin/bash'

# Manage aliases
chal gs 'git status -sb'    # Change
rmal gs                      # Remove
cpal gp gpush               # Copy
mval gpush gpo              # Rename

# List and search
lsal                        # List all
algrep git                  # Search
```

**Happy aliasing!** 🚀

