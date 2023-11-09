#!/bin/bash

# URL of the YAML file to download
YAML_URL="https://raw.githubusercontent.com/gnosischain/specs/master/consensus/config/gnosis.yaml"
# Path to the local YAML file
LOCAL_YAML_PATH="mainnet/config.yaml"

# Download and replace the local YAML file
curl -s -o "$LOCAL_YAML_PATH" "$YAML_URL"

# Check for a git diff
git diff --exit-code
DIFF_STATUS=$?

if [ $DIFF_STATUS -ne 0 ]; then
    echo "Gnosis config is not synced."
    exit 1
else
    echo "Gnosis config synced."
fi

