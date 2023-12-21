#!/bin/bash

echo "Enter the path of compressed backup file"
read path


#go to backup directory to be able to extract and decompress the backup file
path_of_directory=${path%/*}
backup_file=${path##*/}
cd $path_of_directory


#create temp directory to extract and decompress the backup file on it 
mkdir mongo_db
tar xvfz $backup_file -C ./mongo_db


#go to temp directory to restore the databases 
cd mongo_db
cd $(ls)
mongorestore --dir . 


#delete the temp directort
cd $path_of_directory
rm -r mongo_db 
