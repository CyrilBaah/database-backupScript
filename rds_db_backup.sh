#!/bin/bash

# DATABASE_NAME=realtimeapp
# DB_USERNAME=root
# DB_PASSWORD=password123 
# BUCKET_NAME=amalitech-db-backup
# BACKUP_DIRECTORY 

# MYSQL_HOST=arms-db.ck0dwzfc16xf.eu-west-1.rds.amazonaws.com
# MYSQL_PORT=3306
# MYSQL_USER=root
# MYSQL_PASSWORD=amalitech
# DATABASE_NAME=realtimeapp

# MYSQL_HOST=arms-db.ck0dwzfc16xf.eu-west-1.rds.amazonaws.com
# MYSQL_PORT=3306
# MYSQL_USER=admin
# MYSQL_PASSWORD=amalitech
# DATABASE_NAME=realtimeapp

# Load environment variables from .env file
while read -r line || [[ -n "$line" ]]; do
  if [[ $line =~ ^[A-Za-z_]+=[^\#]+ ]]; then
    export "$line"
  fi
done < .env

# Set the backup file name
BACKUP_FILE=$DATABASE_NAME"backup_online_$(date +%Y-%m-%d_%H-%M-%S).sql"

echo $MYSQL_HOST
echo $MYSQL_PORT
echo $MYSQL_USER
echo $MYSQL_PASSWORD
echo $DATABASE_NAME




# Create the backup file
# mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DATABASE_NAME > $BACKUP_FILE
# mysql -h arms-db.ck0dwzfc16xf.eu-west-1.rds.amazonaws.com -P 3306 -u admin -p
 ####
# mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME
# mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD --single-transaction $DATABASE_NAME > $BACKUP_FILE
mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_FILE

# mysqldump -h arms-db.ck0dwzfc16xf.eu-west-1.rds.amazonaws.com -P 3306 -u admin -p realtimeapp


# mysql -h arms-db.ck0dwzfc16xf.eu-west-1.rds.amazonaws.com -P 3306 -u admin -p realtimeap

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
