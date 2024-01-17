#!/bin/bash

file1="chiado/config.yaml"
file2="mainnet/config.yaml"

# Extract keys, ignoring comments and sort them
keys1=$(grep -o '^[^#][^:]*' "$file1" | sort)
keys2=$(grep -o '^[^#][^:]*' "$file2" | sort)

# Compare keys
diff <(echo "$keys1") <(echo "$keys2") > /dev/null

if [ $? -eq 0 ]; then
    echo "Chiado config has same keys as mainnet."
else
    echo "Chiado config and mainnet keys differ."
    echo "Differences:"
    diff <(echo "$keys1") <(echo "$keys2")
fi
