#!/usr/bin/env zsh
# Auto-fix common alias file issues during import
# This script validates and repairs broken alias definitions

if [ $# -lt 1 ]; then
    echo "Usage: $0 <alias-file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE}.fixed"
BACKUP_FILE="${INPUT_FILE}.backup"

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Error: File not found: $INPUT_FILE"
    exit 1
fi

echo "🔍 Validating and fixing aliases in: $INPUT_FILE"
echo ""

# Create backup
cp "$INPUT_FILE" "$BACKUP_FILE"
echo "💾 Created backup: $BACKUP_FILE"

# Statistics
total_lines=0
fixed_lines=0
skipped_lines=0

# Create output file with header if it was in the input
if head -1 "$INPUT_FILE" | grep -q "^#"; then
    head -1 "$INPUT_FILE" > "$OUTPUT_FILE"
fi

echo ""
echo "🔧 Processing aliases..."

# Process each line
while IFS= read -r line; do
    ((total_lines++))
    
    # Skip empty lines
    if [[ -z "$line" ]]; then
        echo "$line" >> "$OUTPUT_FILE"
        continue
    fi
    
    # Keep comment lines as-is
    if [[ "$line" == \#* ]]; then
        echo "$line" >> "$OUTPUT_FILE"
        continue
    fi
    
    # Process alias lines
    if [[ "$line" == alias* ]]; then
        # Check for unmatched quotes
        single_quotes=$(echo "$line" | grep -o "'" | wc -l | xargs)
        double_quotes=$(echo "$line" | grep -o '"' | wc -l | xargs)
        
        # If unmatched single quotes
        if [[ $((single_quotes % 2)) -ne 0 ]]; then
            # Extract alias name
            alias_name=$(echo "$line" | sed -E 's/^alias ([^=]+)=.*/\1/')
            
            # Check if line ends with a quote or is missing one
            if [[ "$line" =~ \'$ ]]; then
                # Line ends with quote but has odd number - likely has embedded quote
                echo "⚠️  Warning: Line $total_lines has embedded quote: $alias_name"
                echo "$line" >> "$OUTPUT_FILE"
                ((skipped_lines++))
            else
                # Missing closing quote - add it
                echo "✅ Fixed line $total_lines: Added missing closing quote for '$alias_name'"
                echo "${line}'" >> "$OUTPUT_FILE"
                ((fixed_lines++))
                continue
            fi
        # If unmatched double quotes  
        elif [[ $((double_quotes % 2)) -ne 0 ]]; then
            alias_name=$(echo "$line" | sed -E 's/^alias ([^=]+)=.*/\1/')
            
            if [[ "$line" =~ \"$ ]]; then
                echo "⚠️  Warning: Line $total_lines has embedded quote: $alias_name"
                echo "$line" >> "$OUTPUT_FILE"
                ((skipped_lines++))
            else
                echo "✅ Fixed line $total_lines: Added missing closing quote for '$alias_name'"
                echo "${line}\"" >> "$OUTPUT_FILE"
                ((fixed_lines++))
                continue
            fi
        else
            # Quotes are balanced - keep as-is
            echo "$line" >> "$OUTPUT_FILE"
        fi
    else
        # Non-alias line
        echo "$line" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

echo ""
echo "=============================="
echo "📊 Validation Summary:"
echo "   📄 Total lines: $total_lines"
echo "   ✅ Fixed: $fixed_lines"
echo "   ⚠️  Warnings: $skipped_lines"
echo ""

if [[ $fixed_lines -gt 0 ]]; then
    echo "🎯 Applying fixes..."
    mv "$OUTPUT_FILE" "$INPUT_FILE"
    echo "✅ Fixed file saved to: $INPUT_FILE"
    echo "💾 Original backed up to: $BACKUP_FILE"
else
    rm "$OUTPUT_FILE" 2>/dev/null
    echo "✅ No fixes needed - file is valid!"
    rm "$BACKUP_FILE"
fi

echo ""
echo "Done! You can now import this file safely."

