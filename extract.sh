#!/bin/bash

INPUT_FILE="./messages.txt"
OUTPUT_FILE="clients.csv"

# Create output file with header if it doesn't exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "FirstName,SecondName,Phone" > "$OUTPUT_FILE"
fi

# Only process payments sent to JOSSNADGENERALMERCHANTS
grep -i "to JOSSNADGENERALMERCHANTS" "$INPUT_FILE" | while read -r line; do
    # Extract full name
    full_name=$(echo "$line" | grep -oP 'by \K[A-Z ]+(?= Phone)' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')
    phone=$(echo "$line" | grep -oP 'Phone \K[0-9]+')

    # Break into first and second name
    first_name=$(echo "$full_name" | awk '{print $1}')
    second_name=$(echo "$full_name" | awk '{print $2}')

    if [[ -n "$first_name" && -n "$second_name" && -n "$phone" ]]; then
        echo "$first_name,$second_name,$phone" >> "$OUTPUT_FILE"
    fi
done

echo "Done. Extracted and saved to $OUTPUT_FILE"
