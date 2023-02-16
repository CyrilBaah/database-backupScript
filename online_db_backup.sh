#!/bin/bash

# Load environment variables from .env file
while read -r line || [[ -n "$line" ]]; do
  if [[ $line =~ ^[A-Za-z_]+=[^\#]+ ]]; then
    export "$line"
  fi
done < .env

# Connect to the database server and list all databases
databases=$(mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | awk '{ print $1}' | grep -v Database)

# Loop through the list of databases and print each one
for DATABASE_NAME in $databases; do
    echo $DATABASE_NAME

    BACKUP_FILE=$DATABASE_NAME"backup_$(date +%Y-%m-%d_%H-%M-%S).sql"

    # Create the backup file
    mysqldump -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_FILE

    # Check if the backup file was created successfully
    if [ $? -eq 0 ]; then

      cd $CURRENT_DIRECTORY
      # Upload the backup file to the S3 bucket 
      aws s3 cp $CURRENT_DIRECTORY/$BACKUP_FILE s3://$BUCKET_NAME/

      # Check if the upload was successful
      if [ $? -eq 0 ]; then
        # Remove the backup file
        rm $BACKUP_FILE
        rm *.sql
        echo "Backup completed successfully and file removed"
      else
        echo "Error uploading the backup file to the S3 bucket"
      fi
    else
      echo "Error creating the backup file"
    fi
done
