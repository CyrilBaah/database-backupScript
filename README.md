# database-backupScript
This Bash script is to automatically backup your database itself. An example a
maybe a database cluster that contains a lot og databases. This scripts backups
individual databases in the specified database cluster.

# Info
This is in two forms
- Local backup: Backups your local database and copies sql files to s3 bucket.
- Online backup: Backups the online database and copies sql files to s3 bucket.

# Usage
1. Clone project
```sh
$ git clone https://github.com/CyrilBaah/database-backupScript.git
```
2. Change directory to the current working directory
3. Configure .env.example to .env with correct details
4. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html "AWS CLI")
5. Configure AWS CLI with
```sh
$ aws configure
```
6. Make the script executable depending on the your preference
```sh
$ chmod +x local_db_backup.sh
```
Or
```sh
$ chmod +x online_db_backup.sh
```