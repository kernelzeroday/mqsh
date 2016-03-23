#!/bin/sh
#make a cmd json
ip=`/sbin/ifconfig lo | grep Mask | cut -d ':' -f2 | cut -d " " -f1`
uname=`uname`
cat format.json | sed "s/CHANGEIP/$ip/" | sed "s/CHANGEUNAME/$uname/" > data.json
cat cmd >> data.json
printf %s \"\} >> data.json
cat data.json | sed ':a;N;$!ba;s/output\"\ :\ \"\n/output\"\ :\ \"/' > output.json
>data.json


