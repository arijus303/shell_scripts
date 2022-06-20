#!/bin/bash

compressProg=(gzipFUNC bzip2FUNC )
#this is for total count of compression programs, all of them are going to be used so we need to take preliminary 
#size of compression and multiply by total program count. This way we can check if we have enough space to 
#per form compression tests.
totalFuncNum=${#compressProg[@]}
testDir="/tmp/compression_test_$$/"
i=10
#FILENAME=$1
#check if file exists
#ckeck if we have a total space

#####################################################
#COMPRESSION FUNCTIONS:
#####################################################

function gzipFUNC(){

	echo "gzip - attempting to compress: $2"
	id=$1 
	gzip -c "$2" > "$testDir$id"
	STATUS=$?
	if [[ $STATUS -eq 0 ]];then
	       echo "gzip - completed."
       	else
	       echo "gzip - error while compressing."
       	fi	       
	
}

function bzip2FUNC(){

	echo "bzip2 - attempting to compress: $2"
	id=$1 
	bzip2 -c "$2" > "$testDir$id"
	STATUS=$?
	if [[ $STATUS -eq 0 ]];then
	       echo "bzip2 - completed."
       	else
	       echo "bzip2 - error while compressing."
       	fi	       
	
}
#######################################################
#######################################################


id=0
mkdir -p $testDir
trap 'rm -rf "$testDir"' EXIT

for FILENAME in $@; do

	if [[ -f $FILENAME ]]; then


	for func in ${compressProg[@]}; do
	
		$func $id $FILENAME
		((id++))
			
		done
		#<- write a comparison function and append result to log.
	else
		echo "File [ $FILENAME ] does not exist!, please check and try again" >&2
		continue
	
	fi
done

	

	
