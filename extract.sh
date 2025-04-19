#!/bin/bash

INPUT_FILE="./messages.txt"
OUTPUT_FILE="clients.csv"

# add CSV header if the file doesn't exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "Name,Phone" > "$OUTPUT_FILE"
fi

# process each line
while IFS= read -r line; do
    # extract the part with "by NAME Phone NUMBER"
    match=$(echo "$line" | grep -oP 'by \K[A-Z ]+(?= Phone [0-9]+)')
    phone=$(echo "$line" | grep -oP 'Phone \K[0-9]+')

    if [[ -n "$match" && -n "$phone" ]]; then
        name=$(echo "$match" | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')  # trim spaces
        echo "$name,$phone" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

echo "Done. Extracted data saved to $OUTPUT_FILE"

