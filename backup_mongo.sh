#!/bin/bash

#choose location of generated file 
echo "Enter the backup path ended with file name with extention .tar.gz"
read path


#choose host and port
echo "Enter the host"
read host_name
echo "Enter the port"
read port_number


#check if there is Authentication to access the mongo db or not
echo "if database has authentication press Y if hasn't press Enter "
read authentication_check


#install mongo-tool if not  installed to be able to use mongodump
validate=$(command -v mongodump)

if [[ -z $validate ]];then
sudo apt update 
sudo apt install mongo-tools
fi

filename=$(basename $path)  #seperate the file name from the path
cd ${path%/*} #go to the backup directory
mkdir mongo #create temp directory to store databases directories on it
cd mongo
path=$PWD


#dump all databases wether there is authentication or not
if [[ {$authentication_check} == "Y" ]];then
echo "Enter the username"
read username
echo "enter the password"
read password
mongodump --host $host_name --port $port_number --username $username --password $password --out $path
else
mongodump --host $host_name --port $port_number  --out $path
fi

cd .. #back to backup directory to be able to archieve and compress the temp directory
temp_dir=${path##*/}
tar cvfz   $filename $temp_dir
rm -r $temp_dir #remove the temp directory
