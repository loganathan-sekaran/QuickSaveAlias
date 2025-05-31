#!/usr/bin/env zsh
# This script helps convert and merge Bash aliases into Zsh aliases,
# giving preference to existing Zsh aliases in case of conflicts

convert_and_merge_aliases() {
    local bash_aliases_file=$1
    local zsh_aliases_file=$2
    
    # Check if input files exist
    if [ ! -f "$bash_aliases_file" ]; then
        echo "Error: Bash aliases file '$bash_aliases_file' not found."
        return 1
    fi
    
    # Create zsh aliases file if it doesn't exist
    if [ ! -f "$zsh_aliases_file" ]; then
        touch "$zsh_aliases_file"
    fi
    
    echo "Converting Bash aliases from '$bash_aliases_file' to Zsh format and merging with '$zsh_aliases_file'..."
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Get existing aliases from zsh file as a map for conflict checking
    declare -A existing_aliases
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ ]]; then
            continue
        fi
        
        # Extract alias name (before =)
        if [[ "$line" == *"="* ]]; then
            local alias_name=$(echo "$line" | cut -d'=' -f1)
            existing_aliases[$alias_name]=1
        fi
    done < "$zsh_aliases_file"
    
    # Copy existing zsh aliases to temp file
    cat "$zsh_aliases_file" > "$temp_file"
    
    # Process bash aliases and append non-conflicting ones
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ || "$line" =~ ^// ]]; then
            continue
        fi
        
        # Process alias definitions
        if [[ "$line" == alias* ]]; then
            # Remove the 'alias ' prefix and handle formats like:
            # alias foo='bar'
            # alias foo='bar baz'
            # alias foo="bar baz"
            line=${line#alias }
            
            # Extract alias name and value
            if [[ "$line" =~ ^([[:alnum:]_-]+)=(.+)$ ]]; then
                local name=${BASH_REMATCH[1]}
                local value=${BASH_REMATCH[2]}
                
                # Remove surrounding quotes if present
                value=$(echo "$value" | sed -E "s/^[\"'](.*)[\"\']$/\\1/")
                
                # Check for conflict
                if [[ -z "${existing_aliases[$name]}" ]]; then
                    # No conflict, add the alias
                    # Check if this is a special character alias
                    if [[ "$name" == -* || "$name" == .* || "$name" == [0-9]* || 
                          "$name" == *-* || "$name" == *+* || "$name" == *\** || 
                          "$name" == *\!* || "$name" == *\&* || "$name" == *=* ||
                          "$name" == *\?* || "$name" == *\#* || "$name" == *\$* ||
                          "$name" == *\%* || "$name" == *\^* || "$name" == *\~* ||
                          "$name" == *\@* || "$name" == *\/* || "$name" == *\\* ]]; then
                        # For special character aliases, use single quotes
                        echo "$name='$value'" >> "$temp_file"
                    else
                        # Regular alias
                        echo "$name=$value" >> "$temp_file"
                    fi
                fi
            fi
        fi
    done < "$bash_aliases_file"
    
    # Replace the zsh aliases file with the merged content
    mv "$temp_file" "$zsh_aliases_file"
    
    echo "Conversion and merge complete. Aliases merged into '$zsh_aliases_file'"
    echo "Note: Existing aliases in '$zsh_aliases_file' were given preference."
}

# If the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <bash_aliases_file> <zsh_aliases_file>"
        exit 1
    fi
    convert_and_merge_aliases "$1" "$2"
fi
