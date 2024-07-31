#!/bin/bash

# Check if the file path argument is provided
if [ -z "$1" ]; then
    echo "Please provide the path to the accounts.csv file."
    exit 1
fi

input_file="$1"
output_file="accounts_new.csv"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "The file $input_file does not exist."
    exit 1
fi

# Function to process the name
process_name() {
    echo "$1" | awk 'BEGIN {FS=OFS=" "} {for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))} 1'
}

# Function to generate the email
generate_email() {
    name=$1
    surname=$2
    email_prefix=$(echo "${name:0:1}${surname}" | tr '[:upper:]' '[:lower:]')
    echo "${email_prefix}@abc.com"
}

# Read the header of the CSV file
header=$(head -n 1 "$input_file")

# Write the header to the new file
echo "$header" > "$output_file"

# Read and process each line of the input file, handling commas within quoted fields
awk -v OFS=',' -v output_file="$output_file" '
BEGIN {
    FPAT = "([^,]*)|(\"[^\"]+\")"
}
NR > 1 {
    id = $1
    location_id = $2
    name = $3
    title = $4
    email = $5
    department = $6

    # Remove surrounding quotes from fields if they exist
    gsub(/^"|"$/, "", name)
    gsub(/^"|"$/, "", title)
    gsub(/^"|"$/, "", email)
    gsub(/^"|"$/, "", department)

    # Process the name
    processed_name = name
    gsub(/(^| )([a-z])/, "\\U\\2", processed_name)  # Capitalize first letter of each part of the name

    # Split the processed name into first name and surname
    split(processed_name, name_parts, " ")
    first_name = name_parts[1]
    surname = name_parts[2]

    # Generate the email
    new_email = tolower(substr(first_name, 1, 1) surname "@abc.com")

    # Check for email duplicates and append location_id if necessary
    if (system("grep -q \"" new_email "\" \"" output_file "\"") == 0) {
        new_email = tolower(substr(first_name, 1, 1) surname "_" location_id "@abc.com")
    }

    # Write the processed data to the new file
    print id, location_id, processed_name, title, new_email, department > output_file
}' "$input_file"

echo "Processing complete. New file created: $output_file"
