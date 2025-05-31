#!/usr/bin/env bash
# This script helps convert and merge Bash aliases into an existing aliases file,
# giving preference to existing aliases in case of conflicts

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

# If the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <source_aliases_file> <target_aliases_file>"
        exit 1
    fi
    convert_and_merge_aliases "$1" "$2"
fi
