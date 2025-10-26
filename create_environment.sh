
#!/bin/bash
#creating an application to remind students to submit

#ask the student to enter their name
read -p "Enter your name: " name
mkdir -p submission_reminder_$name

applidir="submission_reminder_$name"
#creating sub-directories
mkdir -p "$applidir/app"
mkdir -p "$applidir/modules"
mkdir -p "$applidir/assets"
mkdir -p "$applidir/config"

#creating the files in their respective directories

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > $applidir/config/config.env

echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
 " > $applidir/assets/submissions.txt

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > $applidir/modules/functions.sh

#reminding script 
echo '#!/bin/bash

# Source environment variables and help
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"


# printing the remaining time
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > $applidir/app/reminder.sh

#startup.sh 
echo '
#!/bin/bash
if [ -f "./app/reminder.sh" ]; then
    ./app/reminder.sh
else
    echo "Failed to create reminder.sh not found in app/ directory"
exit 1
fi
' > $applidir/startup.sh
#giving scripts permission to  excecute
chmod +x $applidir/app/reminder.sh
chmod +x $applidir/modules/functions.sh
chmod +x $applidir/assets/submissions.txt
chmod +x $applidir/startup.sh

