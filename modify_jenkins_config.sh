#!/bin/bash

# Ensure required environment variables are set
if [ -z "$JENKINS_URL" ] || [ -z "$JOB_NAME" ] || [ -z "$ACTION" ]; then
  echo "Error: Required environment variables (JENKINS_URL, JOB_NAME, ACTION) are not set."
  exit 1
fi

# Validate ACTION
if [ "$ACTION" != "enable" ] && [ "$ACTION" != "disable" ]; then
  echo "Error: ACTION must be 'enable' or 'disable'."
  exit 1
fi

# Get the current job configuration XML
curl -s "$JENKINS_URL/job/$JOB_NAME/config.xml" -o config.xml

# Backup the original config file
cp config.xml config_backup.xml

# Update the config file based on the action
if [ "$ACTION" == "enable" ]; then
    # Enable editable email notification (example pattern)
    sed -i '/<hudson.plugins.emailext.ExtendedEmailPublisher>/,/<\/hudson.plugins.emailext.ExtendedEmailPublisher>/s/<enabled>false<\/enabled>/<enabled>true<\/enabled>/g' config.xml
elif [ "$ACTION" == "disable" ]; then
    # Disable editable email notification (example pattern)
    sed -i '/<hudson.plugins.emailext.ExtendedEmailPublisher>/,/<\/hudson.plugins.emailext.ExtendedEmailPublisher>/s/<enabled>true<\/enabled>/<enabled>false<\/enabled>/g' config.xml
fi

# Update the job configuration
curl -s -X POST -H "Content-Type: text/xml" --data-binary @config.xml "$JENKINS_URL/job/$JOB_NAME/config.xml"

# Clean up
rm config.xml
