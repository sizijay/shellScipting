#!/bin/sh


ttl=$(ping -c 1 $1 | awk {'print $6'} | grep -o '[0-9][0-9]*')
# ttl=$(cat ttl.txt)

ttlInt=$(echo "$ttl + 1" | bc)

tcpdump -t -i en0 icmp >> tcp.txt &
# PID=$!

printf "\nWORKING\nPlease Wait...\n\n"

x=1
while [[ $x -lt $ttlInt ]]
	
do
	ping -m $x -c 1 $1 >> ipAddress.txt
	let x=x+1 
done


cat ipAddress.txt | awk '{print $4}' >> ip.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip.txt | uniq >> route.txt



route=$(cat route.txt)


res="\t\t"
res2="\t\t\t"
space="  "
ms=" ms"

printf "\n"

printf "<Hop#>$res<RTT>$res2<COUNTRY>$res<IP>$res<DOMAIN>\n"
printf "\n"
HOP=1



#Time Calculation
for j in $route
do
	
	RTT=$(ping -c 3 $j | tail -1| awk '{print $4}' | cut -d '/' -f 2)
	if [[ $RTT = "0" ]]; then
		RTT="**********"
	else
		RTT="$RTT""$ms"
	fi

	IP=$j
	#COUNTRY=$(whois "$j" | grep -E "country" | awk '{printf $2}' | uniq )
	COUNTRY=$(whois "$j" | awk ' /country/{printf $2}')
	if [[ $COUNTRY = "" ]]; then
		COUNTRY="*"
	fi
	COUNTRYCODE="${COUNTRY:0:2}"
	DOMAIN=$(host $j | rev | cut -d" " -f1 | rev)
	if [[ $DOMAIN = '3(NXDOMAIN)' ]] ; then
		DOMAIN="*"
	elif [[ $DOMAIN = '2(SERVFAIL)' ]] ; then
		DOMAIN="*"
	fi
	
	printf "  $HOP""$res""$RTT""$res""$space""$COUNTRYCODE""$res""$space""$IP""$res""$DOMAIN\n"
	let HOP+=1

done

rm ip.txt
rm ipAddress.txt
rm route.txt
rm tcp.txt



