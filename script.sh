#!/bin/bash


files_with_decoding_issue=""
for FILE in $(find . -type f \( -name 'bootnodes.yaml' -o -name 'bootstrap_nodes.txt' \)); do
  echo "Testing decoding in file: $FILE"
  while read -r LINE; do
    if [[ "$LINE" =~ enr: ]]; then
      if [[ "$LINE" =~ ^\ *- ]]; then
        # For YAML format, extract the part after the "enr:" and the colon and trim any leading/trailing spaces and quotes
        BASE64_STRING=$(echo "$LINE" | awk -F "enr:" '{print $2}' | awk '{$1=$1; gsub(/\"/, "", $0); print}')
      else
        # For text files, just extract the part after "enr:" and trim leading/trailing spaces and quotes
        BASE64_STRING=${LINE#enr:}
        BASE64_STRING=$(echo "$BASE64_STRING" | awk '{$1=$1; gsub(/\"/, "", $0); print}')
      fi

      echo "Base64 string: $BASE64_STRING"  # Echo the resulting base64 string

      DECODED_STRING=$(echo "$BASE64_STRING" | base64 -d 2>/dev/null)
      if [ $? -ne 0 ]; then
        if [[ "$files_with_decoding_issue" != *"$FILE"* ]]; then
          echo "Error: ENR could not be decoded in $FILE: enr:$BASE64_STRING"
          files_with_decoding_issue="$files_with_decoding_issue $FILE"
        fi
      fi
    fi
  done < "$FILE"
done

if [ -n "$files_with_decoding_issue" ]; then
  echo "Error: Bootnodes ENR strings have decoding issues in the following files:"
  echo "$files_with_decoding_issue"
  exit 1
fi







