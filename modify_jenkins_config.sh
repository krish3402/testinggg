#!/bin/bash

# Define the job name and Jenkins home directory
JOB_NAME="testinggg"
JENKINS_HOME="/var/jenkins_home"

# Define the path to the job's config.xml
JOB_CONFIG="$JENKINS_HOME/jobs/$JOB_NAME/config.xml"

# Define the action to be taken: enable or disable
ACTION=$1

if [ "$ACTION" != "enable" ] && [ "$ACTION" != "disable" ]; then
    echo "Usage: $0 [enable|disable]"
    exit 1
fi

# Backup the original config.xml
cp "$JOB_CONFIG" "$JOB_CONFIG.bak"

# Use sed to enable or disable Editable Email Notification
if [ "$ACTION" == "enable" ]; then
    sed -i 's/<email-notifications>false<\/email-notifications>/<email-notifications>true<\/email-notifications>/' "$JOB_CONFIG"
elif [ "$ACTION" == "disable" ]; then
    sed -i 's/<email-notifications>true<\/email-notifications>/<email-notifications>false<\/email-notifications>/' "$JOB_CONFIG"
fi

# Reload the Jenkins job configuration
curl -X POST "http://localhost:8080/job/$JOB_NAME/config.xml" --data-binary @"$JOB_CONFIG" -H "Content-Type: application/xml"

# Clean up
rm "$JOB_CONFIG.bak"
