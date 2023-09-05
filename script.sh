#!/bin/bash

for FILE in $(find . -type f \( -name 'bootnodes.yaml' -o -name 'bootstrap_nodes.txt' \)); do
  echo "Decoding file: $FILE"
  while read -r LINE; do
    if [[ "$LINE" =~ enr: ]]; then
      BASE64_STRING=${LINE#enr:}
      DECODED_STRING=$(echo "$BASE64_STRING" | base64 -d 2>/dev/null)
      if [ $? -eq 0 ]; then
        echo "Succesfully decoded ENR in $FILE"
      else
        echo "Base64 string could not be decoded in $FILE: $BASE64_STRING"
        exit 1
      fi
    fi
  done < "$FILE"
done
