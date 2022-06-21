#!/bin/bash

compressProg=(gzipFUNC bzip2FUNC) #<-
compressProgName=(gzip bzip2) #<-
#this is for total count of compression programs, all of them are going to be used so we need to take preliminary 
#size of compression and multiply by total program count. This way we can check if we have enough space to 
#per form compression tests.
totalFuncNum=${#compressProg[@]}
testDir="/tmp/compression_test_$$/"
i=10
#ckeck if we have a total space

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 [file/s name to test]" >&2
	exit 1
fi

#####################################################
#COMPRESSION FUNCTIONS:
#####################################################

function gzipFUNC(){

	local NAME=${compressProgName[$1]}

	echo "$NAME - attempting to compress: $2"
	id=$1 
	gzip -c "$2" > "$testDir$id" #<-
	STATUS=$?
	if [[ $STATUS -eq 0 ]];then
	       echo "$NAME - completed."
       	else
	       echo "$NAME - error while compressing."
       	fi	       
	
}

function bzip2FUNC(){

	local NAME=${compressProgName[$1]}

	echo "$NAME - attempting to compress: $2"
	id=$1 
	bzip2 -c "$2" > "$testDir$id"
	STATUS=$?
	if [[ $STATUS -eq 0 ]];then
	       echo "$NAME - completed."
       	else
	       echo "$NAME - error while compressing."
       	fi	       
	
}
#######################################################
#COMPRESSION FUNCTIONS END
#######################################################

function compare() {

        local __FILENAME=$1
        echo "Comparing @ $testDir"
        smallest_size=`ls -l $testDir | awk 'NR>1{print $5}' | sort -n | head -1`
        functionID=`ls -l $testDir | grep $smallest_size | awk '{print $9}'`

        
        echo "Best compression for file $__FILENAME is ${compressProgName[$functionID]}"
}


id=0
mkdir -p $testDir
trap 'rm -rf "$testDir"' EXIT #clean up after test.

for FILENAME in $@; do

	if [[ -f $FILENAME ]]; then


	for func in ${compressProg[@]}; do
	
		check_for_space $id #check for space availability
		$func $id $FILENAME #function call to compress
		((id++))
			
		done
		compare $FILENAME 
	else
		echo "File [ $FILENAME ] does not exist!, please check and try again" >&2
		continue
	
	fi
done

	

	
