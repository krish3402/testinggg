#!/bin/bash

# Define the job name and Jenkins home directory
JOB_NAME="testinggg"
JENKINS_HOME="/var/jenkins_home"
JOB_CONFIG="$JENKINS_HOME/jobs/$JOB_NAME/config.xml"

# Check if the job config file exists
if [ ! -f "$JOB_CONFIG" ]; then
    echo "Job configuration file not found: $JOB_CONFIG"
    exit 1
fi

# Backup the original config.xml
cp "$JOB_CONFIG" "$JOB_CONFIG.bak"

# Define action (enable or disable) and check for parameter
ACTION=$1
if [ "$ACTION" != "enable" ] && [ "$ACTION" != "disable" ]; then
    echo "Usage: $0 [enable|disable]"
    exit 1
fi

# Define the XML patterns for enabling/disabling email notifications
if [ "$ACTION" == "enable" ]; then
    # Modify the XML to enable Editable Email Notification
    sed -i 's/<email-notifications>false<\/email-notifications>/<email-notifications>true<\/email-notifications>/' "$JOB_CONFIG"
else
    # Modify the XML to disable Editable Email Notification
    sed -i 's/<email-notifications>true<\/email-notifications>/<email-notifications>false<\/email-notifications>/' "$JOB_CONFIG"
fi

# Check if sed command succeeded
if [ $? -ne 0 ]; then
    echo "Failed to update $JOB_CONFIG"
    # Restore the backup if sed fails
    mv "$JOB_CONFIG.bak" "$JOB_CONFIG"
    exit 1
fi

# Clean up backup file
rm "$JOB_CONFIG.bak"

echo "Editable Email Notification has been $ACTIONd for job $JOB_NAME."
