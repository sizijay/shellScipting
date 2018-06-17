#!/bin/bash

cat $1 | awk '{print $1}'> ip.txt

uniq ip.txt > uniqip.txt
IP=$(cat uniqip.txt)



for i in $IP
do
	#much faster
	# printf $i: 
	# curl ipinfo.io/$i/country 
	
	#slower
 	echo "$i : $(whois "$i" | awk ' /country/{printf $2}')"
done