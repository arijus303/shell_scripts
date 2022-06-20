#!/bin/bash

compressProg=(gzipFUNC)
#this is for total count of compression programs, all of them are going to be used so we need to take preliminary 
#size of compression and multiply by total program count. This way we can check if we have enough space to 
#per form compression tests.
totalFuncNum=${#compressProg[@]}
testDir="/tmp/compression_test/"
i=10
filename="compression_test."

#check if file exists
#ckeck if we have a total space

#compression functions:

function gzipFUNC(){
	echo "Gzip - attempting to compress."
	id=$1 
	gzip -c "$2" > "$testDir$id"
	STATUS=$?
	if [[ $STATUS -eq 0 ]];then
	       echo "Gzip - completed."
       	else
	       echo "Gzip - error while compressing."
       	fi	       
	
}

id=0
mkdir -p $testDir

for func in ${compressProg[@]}; do
	
	if [[ -f $1 ]];then
		$func $id $1
		((id++))
		
	else
		echo "File does not exist!, please check and try again" >&2
		exit 1
	fi
done

