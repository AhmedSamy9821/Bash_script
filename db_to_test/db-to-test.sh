#!/bin/bash

#Needed data 
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/backup_directory
username=root
password=admin
data_bases_array=("dev" "support")

#write the date on log file
echo -e "\n\n##########################\n$(date)\n##########################\n" 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/db-to-test.log


#dump process from db instance

#write dump logs 
echo -e "\n\n##########################\ndump logs\n##########################\n" 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/db-to-test.log

cd $backup_path

#dump and compress databases 
for db in ${data_bases_array[@]};do
    file_name=$db.sql

    #dump the database 
    docker exec db mysqldump -u $username -p$password $db > $file_name 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/db-to-test.log
    
    #compress the dump file and ovrride if old one exists
    gzip -f $file_name 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/db-to-test.log
done


#restore process to db-test

#write restore logs 
echo -e "\n\n##########################\nrestore logs\n##########################\n" 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/db_to_test/db-to-test.log


#restore databases from db-test instance
for db in ${data_bases_array[@]};do

    #decompress the database file 
    gunzip $db.sql.gz 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log #decompress the database file 

    #drop database if exists
    condition=$(docker exec db-test mysql  -u $username -p$password -e "SHOW DATABASES;" | grep -w "$db")
    if [ -n "$condition" ];then 
        docker exec db-test mysql -u $username -p$password -e "DROP DATABASE $db;"
    fi

    #restore databases inside container
    docker exec db-test mysql  -u $username -p$password -e "CREATE DATABASE $db;" 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log
    docker exec -i db-test mysql  -u $username -p$password $db < $backup_path/$db.sql 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log

    #compress the original file again to save space 
    gzip $db.sql 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mysql/restore_mysql.log
   
done 



