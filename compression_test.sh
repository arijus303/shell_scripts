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
	bzip2 -c "$2" > "$testDir$id" #<-
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

        
        echo "Best compression for file [ $__FILENAME ] is ${compressProgName[$functionID]}"
}

function check_for_space(){

	if [[ $counter -eq 0 ]]; then
	echo -n "Checkig for sufficient space to perform test... "

	local free=`df --total | grep total | awk '{print $4}'`
	${compressProgName[$1]} -c $2 > /tmp/space_test 
	local size=$(ls -l /tmp/space_test | awk '{print $5}' )
	rm /tmp/space_test
	echo -n "Free space: $free "
	_ARGV=$(($# - 1))
	needed_space=$(($size * $totalFuncNum * $_ARGV))
	echo -n "Space needed(aprox.): $needed_space"
	res=$(($free > $needed_space))
		
		if [[ $res -eq 1 ]];then 
			echo "[OK]"
		else 
			echo "Not enough space to perform compression test, exiting..." 1>&2
			exit 1
		fi
	fi
}


counter=0
mkdir -p $testDir
#trap 'rm -rf "$testDir"' EXIT #clean up after test.

for FILENAME in $@; do

	if [[ -f $FILENAME ]]; then


	for func in ${compressProg[@]}; do
	
		check_for_space $counter $FILENAME #check for space availability, only run once
		$func $counter $FILENAME #function call to compress
		((counter++))
			
		done
		compare $FILENAME 
	else
		echo "File [ $FILENAME ] does not exist!, please check and try again" >&2
		continue
	
	fi
done

	

	
