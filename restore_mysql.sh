#!/bin/bash

#Input data 
echo "Enter the backup path ended with file name "
read path
echo "Enter the IP address of host"
read IP
echo "Enter the port of host"
read port
echo "Enter the user name for connect to mysql"
read username
echo "Enter the password"
read password


#install mysql-client if not  installed to be able to use mysql command
validate=$(command -v mysqldump)

if [[ -z $validate ]];then
sudo apt update > /dev/null
sudo apt install mysql-client-core-8.0 > /dev/null
fi

#restore databases
cd ${path%/*}
filename=$(basename $path)  #seperate the file name from the path
gunzip $filename #decompress the dump file
mysql -h $IP -P $port -u $username -p$password < ${filename%.gz} #restore databases
gzip ${filename%.gz} #compress again after restoring to save space
