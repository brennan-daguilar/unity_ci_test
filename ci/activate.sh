#!/bin/bash

echo "Requesting activation (professional license)"

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
    /opt/unity/Editor/Unity \
      -batchmode \
      -nographics \
      -logFile /dev/stdout \
      -quit \
      -serial "$UNITY_SERIAL" \
      -username "$UNITY_CREDENTIALS_USR" \
      -password "$UNITY_CREDENTIALS_PSW"

# Store the exit code from the verify command
UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  # Activation was a success
  echo ""
  echo "###########################"
  echo "#   Activation complete   #"
  echo "###########################"
  echo ""
else
  echo ""
  echo "###########################"
  echo "#         Failure         #"
  echo "###########################"
  echo ""
  echo "Please note that the exit code is not very descriptive."
  echo "Most likely it will not help you solve the issue."
  echo ""
  echo "To find the reason for failure: please search for errors in the log above."
  echo ""
  exit $UNITY_EXIT_CODE
fi

