#!/bin/bash

# Load environment variables from .env file
while read -r line || [[ -n "$line" ]]; do
  if [[ $line =~ ^[A-Za-z_]+=[^\#]+ ]]; then
    export "$line"
  fi
done < .env

# Set the backup file name
BACKUP_FILE=$DATABASE_NAME"backup_$(date +%Y-%m-%d_%H-%M-%S).sql"

# Create the backup file
mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DATABASE_NAME > $BACKUP_FILE

# Check if the backup file was created successfully
if [ $? -eq 0 ]; then
  # Upload the backup file to the S3 bucket
  aws s3 cp $BACKUP_FILE s3://$BUCKET_NAME/

  # Check if the upload was successful
  if [ $? -eq 0 ]; then
    # Remove the backup file
    rm $BACKUP_FILE
    echo "Backup completed successfully and file removed"
  else
    echo "Error uploading the backup file to the S3 bucket"
  fi
else
  echo "Error creating the backup file"
fi
