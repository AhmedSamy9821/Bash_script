#!/bin/bash

#Nedded data
backup_path=/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/backup_directory
authentication_check="false"
file_name="mongo_test_backup.gz"

#specify the date of logs
echo -e "\n\n##########################\n$(date)\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log
echo -e "\n\n##########################\ndump from mongo-test instance \n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log


#dumping process from mongo test instance


#dump all databases inside container wether there is authentication or not
if [[ $authentication_check == "true" ]];then
username="admin"
password="admin"
auth_database="admin"
docker exec mongo-test mongodump   --username $username --password $password --authenticationDatabase $auth_database --archive=$file_name  --gzip  >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log
else
docker exec mongo-test mongodump --archive=$file_name  --gzip  >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log
fi

#copy the dump file from container to local host
docker cp mongo-test:/$file_name $backup_path


#restore process to db-test instance


echo -e "\n\n##########################\nrestore databases to db-test instance logs\n##########################\n" >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log

backup_path=$backup_path/$file_name


#copy the dump file from local host to container
docker cp $backup_path db-test:/

#restore all databases inside container wether there is authentication or not
if [[ $authentication_check == "true" ]];then
username="admin"
password="admin"
auth_database="admin"
docker exec db-test mongrestore  --username $username --password $password --authenticationDatabase $auth_database --archive=${backup_path##*/}  --gzip >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log
else
docker exec db-test mongorestore --archive=${backup_path##*/}  --gzip >>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log 2>>/home/ahmed98/devops_training/Bash/Git_hub/Bash_script/mongo_to_test/mongo-to-test.log
fi

