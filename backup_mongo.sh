#!/bin/bash

#choose location of generated file and direcrtory
echo "Enter the backup path"
read path
cd $path
mkdir mongo
cd mongo
path=$PWD

#install mongo-tool if not  installed to be able to use mongodump
validate=$(command -v mongodump)

if [[ -z $validate ]];then
sudo apt update 
sudo apt install mongo-tools
fi

#choose host and port
echo "Enter the host"
read host_name

echo "Enter the port"
read port_number

#check if there is Authentication to access the mongo db or not
echo "if database has authentication press Y if hasn't press Enter "
read authentication_check
if [[ {$authentication_check} == "Y" ]];then
echo "Enter the username"
read username
echo "enter the password"
read password
mongodump --host $host_name --port $port_number --username $username --password $password --out $path
else
mongodump --host $host_name --port $port_number  --out $path
fi

cd ..
backup_dir=${path##*/}
backup_file=$backup_dir.tar.gz
tar cvfz   $backup_file $backup_dir
rm -r $backup_dir
echo "all databases dumped on $backup_file"
