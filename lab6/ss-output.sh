#!/bin/bash

DST=$1

touch sender-ss.txt

rm -f sender-ss.txt 

cleanup ()
{
	# get timestamp
	ts=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  |  grep "unacked" |  awk '{print $1}')

	# get sender
	sender=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  | grep "unacked" | awk '{print $6}')


	# retransmissions - current, total
	retr=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  |  grep -oP '\bunacked:.*\brcv_space'  | awk -F '[:/ ]' '{print $4","$5}' | tr -d ' ')


	# get cwnd, ssthresh
	cwn=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"    |  grep "unacked" | grep -oP '\bcwnd:.*(\s|$)\bbytes_acked' | awk -F '[: ]' '{print $2","$4}')

	# concatenate into one CSV
	paste -d ',' <(printf %s "$ts") <(printf %s "$sender") <(printf %s "$retr") <(printf %s "$cwn") > sender-ss.csv

	exit 0
}

trap cleanup SIGINT SIGTERM

while [ 1 ]; do 
	ss --no-header -ein dst $DST | ts '%.s' | tee -a sender-ss.txt 
done
