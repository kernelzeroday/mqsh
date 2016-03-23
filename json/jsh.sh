#!/bin/sh
#make a cmd json
ip=`/sbin/ifconfig lo | grep Mask | cut -d ':' -f2 | cut -d " " -f1`
uname=`uname`
cat format.json | sed "s/CHANGEIP/$ip/" | sed "s/CHANGEUNAME/$uname/" > data.json
#cat /dev/stdin>> data.json
sh -c $1 >> data.json
echo \"\}\ >> data.json
cat data.json | sed ':a;N;$!ba;s/output\"\ :\ \"\n/output\"\ :\ \"/' 
>data.json


