#!/bin/bash

#file operations
inputfile="$1"
outputfile="accounts_new.csv"
header=$(head -n 1 "$inputfile")
echo "$header" > "$outputfile"

#correction of names
firstletterupper() {
    echo "$1" | awk 'BEGIN {FS=OFS=" "} {for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))} 1'
}

#create email username
generate_email() {
    firstname=$1
    lastname=$2
    email_prefix=$(echo "${firstname:0:1}${lastname}" | tr '[:upper:]' '[:lower:]')
    echo "${email_prefix}@domain.com"
}


# processing
tail -n +2 "$inputfile" | while IFS=, read -r id location_id name title email department; do
    processedname=$(firstletterupper "$name")
    
    first_name=$(echo "$processedname" | awk '{print $1}')
    last_name=$(echo "$processedname" | awk '{print $2}')
    
    email=$(generate_email "$first_name" "$last_name")
    
    if grep -q "$email" "$outputfile"; then
        email="${email%@domain.com}_${location_id}@domain.com"
    fi
    
    echo "$id,$location_id,$processedname,$title,$email,$department" >> "$outputfile"

done

echo "Operation complete."
