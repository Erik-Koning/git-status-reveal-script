#!/bin/bash

#number of arguments passed
NUM=$#

#i'th argument
i=0

pathOrig=$(pwd)

#change to the first argument path if given
if [[ "$NUM" != 0 ]]; then
    #look under the first path argument
    i=1	
    CUR_DIR=${!i}
    cd $CUR_DIR
else
    # store the current dir unless path given
    CUR_DIR=$(pwd)
fi

#This while loop seems to often be true but the break statments for variable NUM & i  eject out of the loop
while [[ "$NUM" > 0 || "$i" == 0 ]]; do
   
    printf "Applying git status to all .git repos below the directory:\n$CUR_DIR\n\n"
 
    # Find all git repositories and call git status on them
    for p in $(find . -name ".git" | cut -c 3-); do

        # We have to go to the .git parent directory to call the status command
	cd "$p";
	cd ..;

	#Key words of git status messages that are relevant
	if git status | grep -qE 'Changes|changed|committed|staged|untracked'; then
	    printf "$p\n";
	    git status;
            printf "\n";
	fi

        # lets get back to the base directory
	cd $pathOrig
	
	# If we are looking under argument paths, go back to i'th argument
	if [[ "$i" != 0 ]]; then
            cd ${!i}
	fi
	    
    done
    
    ((NUM--))
    ((i++))
    
    if [[ "$NUM" > 0 ]]; then
	cd $pathOrig
        CUR_DIR=${!i}
	cd $CUR_DIR
    else	    
        break
    fi
    #exit there were no arguments    
    if [[ "$i" == 1 ]]; then
	break
    fi
done

printf "[Complete!]\n"
