#!/bin/bash

read -p "Enter your name: " name

name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

if [ -z "$name" ]; then
    echo "name can't be empty"
    exit 1
fi

if [[ ! $name =~ ^[a-z]+$ ]]; then
    echo "name is invalid"
    exit 1
fi

directory="submission_reminder_$name"
submit_file="$directory/assets/submissions.txt"
config_file="$directory/config/config.env"



#check if directory exists
if [ ! -d "$directory" ]; then
    echo "Directory not found"
    exit 1
fi

read -p "Fill in the assignment name: " assignment
read -p "Fill in remaining submission days: " days

if [[ -z $assignment ]]; then
    echo "assignment not found"
    exit 1
fi
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "days are not filled in"
    exit 1
fi

if [[ ! $assignment =~ ^[a-zA-Z0-9\ ]+$ ]]; then
    echo "Invalid assignment"
    exit 1
fi

# check if the assignment is already present
matched_assignments=$(grep -i ", *$assignment," "$sub_file" | awk -F',' '{print $2}' | head -n1 | xargs)
if [[ -z $matched_assign ]]; then
    echo "Assignment '$assignment' is not found in the submission file"
    exit 1
fi

#change config file 
cat <<EOF > $conf_file
ASSIGNMENT="$matched_assign"
DAYS_REMAINING=$days
EOF

read -p "Do you want to run the app? (y/n): " runApp

if [[ $runApp =~ ^[Yy]$ ]]; then
   echo "The app is processing..."
   cd "$directory"
   ./startup.sh
else
   echo "Sorry, You will use the application later by going to the directory '$directory' and execute './startup.sh'"
fi
