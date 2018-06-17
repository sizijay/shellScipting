#!/bin/bash

d=$(date +%Y%m%d)

#echo basename $($1 $(pwd))
#cp -a $1/. $2/{,.backup.bac}

#to solve the space problem in paths
IFS=$'\n'; set -f

for f in $(find $1 -name '*.*')
	do 

		subPath=${f#"$1"}
		 

		src=$(basename "$subPath")
		dest="$2""$subPath"

		#create target directories if they are not present
		if [ ! -d $(dirname $dest) ]; then
		 	mkdir -p $(dirname $dest)
		fi
		
		#copy files 
		cp "$f" "$2""$subPath"_"$d".bac
		#echo $f
		#echo "$2""$subPath"
	done

#renaming the folders recursively
for dir in $(find $2 -mindepth 1 -type d)
do
	cp -r "$dir" "$dir"_"$d".bac && rm -R "$dir"
	#echo $dir
done

unset IFS; set +f


