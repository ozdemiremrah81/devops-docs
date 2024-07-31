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

# Read and process each line of the input file
tail -n +2 "$input_file" | while IFS=, read -r id location_id name title email department; do
    # Process the name
    processed_name=$(process_name "$name")
    
    # Split the processed name into first name and surname
    first_name=$(echo "$processed_name" | awk '{print $1}')
    surname=$(echo "$processed_name" | awk '{print $2}')
    
    # Generate the email
    new_email=$(generate_email "$first_name" "$surname")
    
    # Check for email duplicates and append location_id if necessary
    if grep -q "$new_email" "$output_file"; then
        new_email="${new_email%@abc.com}_${location_id}@abc.com"
    fi
    
    # Write the processed data to the new file
    echo "$id,$location_id,$processed_name,$title,$new_email,$department" >> "$output_file"
done

echo "Processing complete. New file created: $output_file"
