#!/bin/bash

#Needed data 
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/backup_directory
username=root
password=admin
data_bases_array=("dev" "support")

cd $backup_path

echo -e "\n\n##########################\n$(date)\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log

#restore databases
for db in ${data_bases_array[@]};do

    #decompress the database file 
    gunzip $db.sql.gz 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log #decompress the database file 

    #restore databases inside container
    docker exec db mysql  -u $username -p$password -e "CREATE DATABASE $db;" 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log
    
    docker exec -i db mysql  -u $username -p$password $db < $backup_path/$db.sql 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log

    #compress the original file again to save space 
    gzip $db.sql 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log
   
done 

