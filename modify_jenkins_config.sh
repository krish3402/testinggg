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
    # Add the email notification section if not present
    sed -i '/<\/publishers>/i\
    <hudson.plugins.emailext.ExtendedEmailPublisher plugin="email-ext@1814.v404722f34263">\
      <recipientList>mohan.t@techsophy.com</recipientList>\
      <configuredTriggers>\
        <hudson.plugins.emailext.plugins.trigger.AlwaysTrigger>\
          <email>\
            <subject>$PROJECT_DEFAULT_SUBJECT</subject>\
            <body>$PROJECT_DEFAULT_CONTENT</body>\
            <recipientProviders>\
              <hudson.plugins.emailext.plugins.recipients.DevelopersRecipientProvider/>\
              <hudson.plugins.emailext.plugins.recipients.ListRecipientProvider/>\
            </recipientProviders>\
            <attachmentsPattern></attachmentsPattern>\
            <attachBuildLog>false</attachBuildLog>\
            <compressBuildLog>false</compressBuildLog>\
            <replyTo>$PROJECT_DEFAULT_REPLYTO</replyTo>\
            <contentType>project</contentType>\
          </email>\
        </hudson.plugins.emailext.plugins.trigger.AlwaysTrigger>\
      </configuredTriggers>\
      <contentType>default</contentType>\
      <defaultSubject>$DEFAULT_SUBJECT</defaultSubject>\
      <defaultContent>$DEFAULT_CONTENT</defaultContent>\
      <attachmentsPattern></attachmentsPattern>\
      <presendScript>$DEFAULT_PRESEND_SCRIPT</presendScript>\
      <postsendScript>$DEFAULT_POSTSEND_SCRIPT</postsendScript>\
      <attachBuildLog>false</attachBuildLog>\
      <compressBuildLog>false</compressBuildLog>\
      <replyTo>$DEFAULT_REPLYTO</replyTo>\
      <from></from>\
      <saveOutput>false</saveOutput>\
      <disabled>false</disabled>\
    </hudson.plugins.emailext.ExtendedEmailPublisher>' "$JOB_CONFIG"
else
    # Remove the email notification section if present
    sed -i '/<hudson.plugins.emailext.ExtendedEmailPublisher/,/<\/hudson.plugins.emailext.ExtendedEmailPublisher>/d' "$JOB_CONFIG"
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

echo "Editable Email Notification has been $ACTIONd for job $JOB_NAME."
