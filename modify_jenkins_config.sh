#!/bin/bash

# Define variables
JENKINS_HOME="/var/jenkins_home"  # Adjust if Jenkins is installed elsewhere
JOB_NAME="testinggg"
JOB_CONFIG_XML="${JENKINS_HOME}/jobs/${JOB_NAME}/config.xml"

# Check if job configuration file exists
if [ ! -f "$JOB_CONFIG_XML" ]; then
  echo "Job configuration file not found: $JOB_CONFIG_XML"
  exit 1
fi

# Function to enable email notifications (disable the "Disable Extended Email Publisher" checkbox)
enable_notifications() {
  sed -i '/<hudson.plugins.emailext.EmailExtPublisher>/,/<\/hudson.plugins.emailext.EmailExtPublisher>/s/<disabled>true<\/disabled>/<disabled>false<\/disabled>/' "$JOB_CONFIG_XML"
}

# Function to disable email notifications (enable the "Disable Extended Email Publisher" checkbox)
disable_notifications() {
  sed -i '/<hudson.plugins.emailext.EmailExtPublisher>/,/<\/hudson.plugins.emailext.EmailExtPublisher>/s/<disabled>false<\/disabled>/<disabled>true<\/disabled>/' "$JOB_CONFIG_XML"
}

# Select action
case "$1" in
  enable)
    enable_notifications
    ;;
  disable)
    disable_notifications
    ;;
  *)
    echo "Usage: $0 {enable|disable}"
    exit 1
    ;;
esac

# Optionally restart Jenkins to apply changes
# echo "Restarting Jenkins..."
# sudo systemctl restart jenkins

echo "Configuration updated successfully."

