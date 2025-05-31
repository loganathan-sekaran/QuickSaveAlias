#!/usr/bin/env zsh
# Test script for QuickSaveAlias special character aliases handling
#
# Usage: source test_special_aliases.sh

echo "Testing QuickSaveAlias special character alias handling..."

# Source the QuickSaveAlias script for testing
source ./quicksavealias_mac.sh -install

# Define some test special character aliases
echo "Adding test special character aliases..."
adal - "cd -"
adal ... "../.."
adal 1 "cd -1"
adal -test "echo 'This is a test'"
adal test-dash "echo 'This has a dash'"
adal test.dot "echo 'This has a dot'"
adal 123test "echo 'This starts with a number'"
adal "test+" "echo 'This has a plus sign'"
adal "test?" "echo 'This has a question mark'"

# Test removing a special character alias
echo "Testing removal of a special character alias..."
rmal -test

# Test changing a special character alias
echo "Testing changing a special character alias..."
chal ... "../../.."

# Test copying a special character alias
echo "Testing copying a special character alias..."
cpal ... .....

# Test moving a special character alias
echo "Testing moving a special character alias..."
mval test-dash test-moved

# Verify aliases were saved properly
echo "Verifying all aliases are saved and loadable..."

# Check the main alias file
echo "Contents of ~/.zsh-aliases:"
cat ~/.zsh-aliases

# Check the special aliases helper
echo "Contents of ~/.zsh_special_aliases.sh:"
cat ~/.zsh_special_aliases.sh

# Show current aliases
echo "Current aliases (should include the test aliases):"
alias

echo "Test complete. Please verify that the special character aliases work correctly."
