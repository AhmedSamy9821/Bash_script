#!/bin/bash

#Needed data 
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/backup_directory
username=root
password=admin
data_bases_array=("dev" "support")

#write the date on log file
echo -e "\n\n##########################\n$(date)\n##########################\n" 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/backup_mysql.log

cd $backup_path

#dump and compress databases 
for db in ${data_bases_array[@]};do
    file_name=$db.sql
    #dump the database 
    docker exec db mysqldump -u $username -p$password $db > $file_name 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/backup_mysql.log
    
    #compress the dump file and ovrride if old one exists
    gzip -f $file_name 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/backup_mysql.log

done


