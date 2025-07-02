#!/bin/bash
#Ashmeet Jolly, 05-2025
#asjoll@utu.fi


# Set the directory where your .nii.gz files are
DATA_DIR="$PWD/tbss/origdata"

# Output file
OUTPUT_FILE="subject_list.txt"

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Loop through matching files and extract subject IDs
for file in "$DATA_DIR"/sub-*__fa.nii.gz; do
    # Get the base filename
    filename=$(basename "$file")
    # Strip off the suffix
    subject_id=${filename%%__fa.nii.gz}
    # Write to output
    echo "$subject_id" >> "$OUTPUT_FILE"
done

echo "Subject list written to $OUTPUT_FILE"

