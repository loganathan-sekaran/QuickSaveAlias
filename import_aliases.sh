#!/usr/bin/env zsh
# Import aliases from backup file to .zsh-aliases
# Giving preference to existing aliases

# Import script location
SCRIPT_DIR=$(dirname "$0")

show_usage() {
    echo "Usage: $0 [options] <backup_file>"
    echo ""
    echo "Import aliases from a backup file into your .zsh-aliases, giving preference to existing aliases."
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -f, --force         Overwrite existing aliases instead of preserving them"
    echo "  -b, --backup        Create a backup of existing .zsh-aliases before importing"
    echo ""
    echo "Examples:"
    echo "  $0 my_aliases_bkup/.bash-aliases"
    echo "  $0 --force my_aliases_bkup/.bash-aliases-dev"
    echo ""
}

# Default values
FORCE=0
CREATE_BACKUP=0
BACKUP_FILE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -f|--force)
            FORCE=1
            shift
            ;;
        -b|--backup)
            CREATE_BACKUP=1
            shift
            ;;
        *)
            if [[ -z "$BACKUP_FILE" ]]; then
                BACKUP_FILE="$1"
                shift
            else
                echo "Error: Unknown option or multiple backup files specified."
                show_usage
                exit 1
            fi
            ;;
    esac
done

# Check if backup file was provided
if [[ -z "$BACKUP_FILE" ]]; then
    echo "Error: No backup file specified."
    show_usage
    exit 1
fi

# Resolve backup file path 
if [[ "$BACKUP_FILE" != /* ]]; then
    # If not an absolute path, try relative to current dir or script dir
    if [[ -f "$BACKUP_FILE" ]]; then
        BACKUP_FILE="$(pwd)/$BACKUP_FILE"
    elif [[ -f "$SCRIPT_DIR/$BACKUP_FILE" ]]; then
        BACKUP_FILE="$SCRIPT_DIR/$BACKUP_FILE"
    elif [[ -f "$SCRIPT_DIR/my_aliases_bkup/$BACKUP_FILE" ]]; then
        BACKUP_FILE="$SCRIPT_DIR/my_aliases_bkup/$BACKUP_FILE"
    else
        echo "Error: Backup file not found: $BACKUP_FILE"
        exit 1
    fi
fi

# Check if backup file exists
if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Target file
ZSH_ALIASES_FILE=~/.zsh-aliases

# Create backup if requested and file exists
if [[ $CREATE_BACKUP -eq 1 && -f "$ZSH_ALIASES_FILE" ]]; then
    BACKUP_DATE=$(date +"%Y%m%d_%H%M%S")
    cp "$ZSH_ALIASES_FILE" "${ZSH_ALIASES_FILE}.backup_${BACKUP_DATE}"
    echo "Created backup at: ${ZSH_ALIASES_FILE}.backup_${BACKUP_DATE}"
fi

# If force mode, just copy file directly for .zsh format or convert for .bash format
if [[ $FORCE -eq 1 ]]; then
    if [[ "$BACKUP_FILE" == *".zsh-aliases"* ]]; then
        # Direct copy for zsh format
        cp "$BACKUP_FILE" "$ZSH_ALIASES_FILE"
        echo "Replaced .zsh-aliases with $BACKUP_FILE"
    else
        # Convert bash format
        if [[ -f "$SCRIPT_DIR/convert_bash_aliases.sh" ]]; then
            # Create empty file first if we're forcing
            > "$ZSH_ALIASES_FILE"
            "$SCRIPT_DIR/convert_bash_aliases.sh" "$BACKUP_FILE" "$ZSH_ALIASES_FILE"
        else
            echo "Error: Converter script not found. Please run from the QuickSaveAlias directory."
            exit 1
        fi
    fi
else
    # Regular merge mode
    if [[ "$BACKUP_FILE" == *".zsh-aliases"* ]]; then
        # For zsh format, we need to handle the merge manually
        if [[ ! -f "$ZSH_ALIASES_FILE" ]]; then
            # If target doesn't exist, just copy
            cp "$BACKUP_FILE" "$ZSH_ALIASES_FILE"
            echo "Copied $BACKUP_FILE to $ZSH_ALIASES_FILE"
        else
            # Need to merge preserving existing aliases
            TMP_FILE=$(mktemp)
            
            # Extract existing alias names for conflict detection
            declare -A existing_aliases
            while IFS= read -r line; do
                if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ ]]; then
                    continue
                fi
                
                if [[ "$line" == *"="* ]]; then
                    alias_name=$(echo "$line" | cut -d'=' -f1)
                    existing_aliases[$alias_name]=1
                fi
            done < "$ZSH_ALIASES_FILE"
            
            # Copy existing aliases
            cat "$ZSH_ALIASES_FILE" > "$TMP_FILE"
            
            # Add non-conflicting aliases from backup
            while IFS= read -r line; do
                if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ ]]; then
                    continue
                fi
                
                if [[ "$line" == *"="* ]]; then
                    alias_name=$(echo "$line" | cut -d'=' -f1)
                    if [[ -z "${existing_aliases[$alias_name]}" ]]; then
                        echo "$line" >> "$TMP_FILE"
                    fi
                fi
            done < "$BACKUP_FILE"
            
            mv "$TMP_FILE" "$ZSH_ALIASES_FILE"
            echo "Merged $BACKUP_FILE into $ZSH_ALIASES_FILE (preserving existing aliases)"
        fi
    else
        # For bash format, use the converter
        if [[ -f "$SCRIPT_DIR/convert_bash_aliases.sh" ]]; then
            "$SCRIPT_DIR/convert_bash_aliases.sh" "$BACKUP_FILE" "$ZSH_ALIASES_FILE"
        else
            echo "Error: Converter script not found. Please run from the QuickSaveAlias directory."
            exit 1
        fi
    fi
fi

# Source the special aliases script to update any special character aliases
if [[ -f ~/.zsh_special_aliases.sh ]]; then
    source ~/.zsh_special_aliases.sh
    echo "Reloaded aliases including special characters"
elif [[ -f ~/.quicksavealias.sh ]]; then
    source ~/.quicksavealias.sh -install
    echo "Installed and synchronized special character aliases"
fi

echo "Import complete. You may need to restart your shell or run 'source ~/.zshrc' to use the new aliases."
