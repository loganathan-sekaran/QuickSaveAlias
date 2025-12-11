#!/usr/bin/env bash
# Import aliases from backup file to .bash-aliases
# Giving preference to existing aliases

# Import script location - handle both direct execution and curl pipe execution
if [[ -f "$0" && "$0" != "bash" && "$0" != "-bash" ]]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")
else
    # When run via curl pipe, use temp directory
    SCRIPT_DIR=""
fi

show_usage() {
    echo "Usage: $0 [options] <backup_file>"
    echo ""
    echo "Import aliases from a backup file into your .bash-aliases, giving preference to existing aliases."
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -f, --force         Overwrite existing aliases instead of preserving them"
    echo "  -b, --backup        Create a backup of existing .bash-aliases before importing"
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

# Check if the source is a URL
TEMP_FILE=""
if [[ "$BACKUP_FILE" == http://* || "$BACKUP_FILE" == https://* ]]; then
    echo "Downloading alias file from URL..."
    TEMP_FILE=$(mktemp)
    if curl -fsSL "$BACKUP_FILE" -o "$TEMP_FILE" 2>/dev/null; then
        BACKUP_FILE="$TEMP_FILE"
        echo "   ✓ Downloaded successfully"
    else
        echo "Error: Failed to download from URL: $BACKUP_FILE"
        exit 1
    fi
else
    # Resolve backup file path 
    if [[ "$BACKUP_FILE" != /* ]]; then
        # If not an absolute path, try relative to current dir or script dir
        if [[ -f "$BACKUP_FILE" ]]; then
            BACKUP_FILE="$(pwd)/$BACKUP_FILE"
        elif [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/$BACKUP_FILE" ]]; then
            BACKUP_FILE="$SCRIPT_DIR/$BACKUP_FILE"
        elif [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/my_aliases_bkup/$BACKUP_FILE" ]]; then
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
fi

# Target file
BASH_ALIASES_FILE=~/.bash-aliases

# Create backup if requested and file exists
if [[ $CREATE_BACKUP -eq 1 && -f "$BASH_ALIASES_FILE" ]]; then
    BACKUP_DATE=$(date +"%Y%m%d_%H%M%S")
    cp "$BASH_ALIASES_FILE" "${BASH_ALIASES_FILE}.backup_${BACKUP_DATE}"
    echo "Created backup at: ${BASH_ALIASES_FILE}.backup_${BACKUP_DATE}"
fi

# Merge function - inlined to avoid file creation issues
convert_and_merge_aliases() {
    local source_aliases_file=$1
    local target_aliases_file=$2
    
    # Check if input files exist
    if [ ! -f "$source_aliases_file" ]; then
        echo "Error: Source aliases file '$source_aliases_file' not found."
        return 1
    fi
    
    # Create target aliases file if it doesn't exist
    if [ ! -f "$target_aliases_file" ]; then
        touch "$target_aliases_file"
    fi
    
    echo "Merging aliases from '$source_aliases_file' to '$target_aliases_file', preserving existing aliases..."
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Get existing aliases from target file as a map for conflict checking
    declare -A existing_aliases
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ || "$line" =~ ^// ]]; then
            continue
        fi
        
        # Process alias definitions
        if [[ "$line" == alias* ]]; then
            # Extract alias name
            # Format is typically 'alias name='value'' or "alias name="value""
            local name=$(echo "$line" | cut -d ' ' -f 2 | cut -d '=' -f 1)
            if [ ! -z "$name" ]; then
                existing_aliases[$name]=1
            fi
        fi
    done < "$target_aliases_file"
    
    # Copy existing aliases to temp file
    cat "$target_aliases_file" > "$temp_file"
    
    # Process source aliases and append non-conflicting ones
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ || "$line" =~ ^// ]]; then
            continue
        fi
        
        # Process alias definitions
        if [[ "$line" == alias* ]]; then
            local name=$(echo "$line" | cut -d ' ' -f 2 | cut -d '=' -f 1)
            if [ ! -z "$name" ] && [ -z "${existing_aliases[$name]}" ]; then
                # No conflict, add the alias
                echo "$line" >> "$temp_file"
            fi
        fi
    done < "$source_aliases_file"
    
    # Replace the target aliases file with the merged content
    mv "$temp_file" "$target_aliases_file"
    
    echo "Merge complete. Aliases merged into '$target_aliases_file'"
    echo "Note: Existing aliases in '$target_aliases_file' were given preference."
}

# If force mode, just copy file directly
if [[ $FORCE -eq 1 ]]; then
    cp "$BACKUP_FILE" "$BASH_ALIASES_FILE"
    echo "Replaced $BASH_ALIASES_FILE with $BACKUP_FILE"
else
    # Regular merge mode - use inline function
    convert_and_merge_aliases "$BACKUP_FILE" "$BASH_ALIASES_FILE"
fi

# Load the aliases if quicksavealias is installed
# Note: We don't need to reload here since the aliases are already written to the file
# The user should source ~/.bashrc or restart their shell to use the new aliases
if [[ -f ~/.quicksavealias.sh ]]; then
    # Try to source it, but don't fail if there are errors
    # The -install flag might try to use functions that aren't loaded yet
    if source ~/.quicksavealias.sh -install 2>/dev/null; then
        echo "Reloaded aliases with QuickSaveAlias"
    else
        # Silently continue - aliases are already in the file
        :
    fi
fi

echo "Import complete. You may need to restart your shell or run 'source ~/.bashrc' to use the new aliases."

# Clean up temp file if we downloaded from URL
if [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]]; then
    rm -f "$TEMP_FILE"
fi
