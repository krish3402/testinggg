#!/bin/bash

# Path to the Jenkins job config file
CONFIG_FILE="$JENKINS_HOME/jobs/$JOB_NAME/config.xml"  # Adjust this path accordingly

# Backup the original config file
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Determine whether to enable or disable email notifications
ACTION=$1  # 'enable' or 'disable'

# if [ "$ACTION" == "enable" ]; then
#     # Enable email notifications
#     sed -i 's/<recipientList><\/recipientList>/<recipientList>youremail@example.com<\/recipientList>/' "$CONFIG_FILE"
#     echo "Enabled email notifications."
# elif [ "$ACTION" == "disable" ]; then
#     # Disable email notifications by clearing the recipient list
#     sed -i 's/<recipientList>.*<\/recipientList>/<recipientList><\/recipientList>/' "$CONFIG_FILE"
#     echo "Disabled email notifications."
# else
#     echo "Usage: $0 {enable|disable}"
#     exit 1
# fi


# Update the config file based on the action
if [ "$ACTION" == "enable" ]; then
    # Enable editable email notification (example pattern)
    sed -i '/<hudson.plugins.emailext.ExtendedEmailPublisher>/,/<\/hudson.plugins.emailext.ExtendedEmailPublisher>/s/<enabled>false<\/enabled>/<enabled>true<\/enabled>/g' "$CONFIG_FILE"
elif [ "$ACTION" == "disable" ]; then
    # Disable editable email notification (example pattern)
    sed -i '/<hudson.plugins.emailext.ExtendedEmailPublisher>/,/<\/hudson.plugins.emailext.ExtendedEmailPublisher>/s/<enabled>true<\/enabled>/<enabled>false<\/enabled>/g' "$CONFIG_FILE"
fi


# Verify if the modification was successful
if diff "$CONFIG_FILE" "${CONFIG_FILE}.bak" >/dev/null; then
    echo "No changes made to the config file."
else
    echo "Config file updated successfully."
fi

# Clean up backup file if needed
rm "${CONFIG_FILE}.bak"
