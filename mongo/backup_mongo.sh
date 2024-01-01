#!/bin/bash

#Nedded data
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_directory
authentication_check="false"
file_name="mongo_backup.gz"


echo -e "\n\n##########################\n$(date)\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log


#dump all databases inside container wether there is authentication or not
if [[ $authentication_check == "true" ]];then
username="admin"
password="admin"
auth_database="admin"
docker exec mongo mongodump   --username $username --password $password --authenticationDatabase $auth_database --archive=$file_name  --gzip  1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log
else
docker exec mongo mongodump --archive=$file_name  --gzip  1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_mongo.log
fi

#copy the dump file from container to local host
docker cp mongo:/$file_name $backup_path

