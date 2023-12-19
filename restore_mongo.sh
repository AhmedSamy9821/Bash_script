#!/bin/bash

echo "Enter the path of compressed backup file"
read path

path_of_directory=${path%/*}
backup_file=${path##*/}
cd $path_of_directory
echo $PWD
tar xvfz $backup_file 
cd mongo
mongorestore --dir .

