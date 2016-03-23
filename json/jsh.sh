#!/bin/sh
#make a cmd json
ip=`/sbin/ifconfig lo | grep Mask | cut -d ':' -f2 | cut -d " " -f1`
unixtime=`date +%s`
date=`date`
uptime=`uptime | sed s/\,//`
ports=`ss -tlp | grep -v Peer |grep 127| tr -s ' ' | cut -f4,6 -d' ' | tr '\n' '!'`
id=`id`
version=`cat /proc/version`
memstat=`cat /proc/meminfo | head -n 3 | tr -s '\n' ' '`
cmdline="$@"
cat format.json | sed "s/CHANGEIP/$ip/" |sed "s/CHANGEUNIXTIME/$unixtime/"|sed "s/CHANGEID/$id/"| sed "s/CHANGEPORTS/$ports/"|sed "s/CHANGEDATE/$date/" | sed "s/CHANGECMDLINE/$cmdline/"|sed "s/CHANGEMEM/$memstat/"|sed "s/CHANGEUPTIME/$uptime/"|sed "s/CHANGEVERSION/$version/"> data.json
#cat /dev/stdin>> data.json
sh -c "$@" >> data.json
echo \"\} >> data.json
cat data.json | sed ':a;N;$!ba;s/output\"\ :\ \"\n/output\"\ :\ \"/' 
>data.json


