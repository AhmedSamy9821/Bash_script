#!/bin/bash

#Nedded data
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/backup_directory/mongo_backup.gz
authentication_check="false"

echo -e "\n\n##########################\n$(date)\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log


#copy the dump file from local host to container
docker cp $backup_path mongo:/

#restore all databases inside container wether there is authentication or not
if [[ $authentication_check == "true" ]];then
username="admin"
password="admin"
auth_database="admin"
docker exec mongo mongrestore  --username $username --password $password --authenticationDatabase $auth_database --archive=${backup_path##*/}  --gzip 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log
else
docker exec mongo mongorestore --archive=${backup_path##*/}  --gzip 1>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo/restore_mongo.log
fi

