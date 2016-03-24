#!/bin/sh
#make a cmd json
bbj=`busybox jshon -s `
ip=$bbj"$(/sbin/ifconfig lo | grep Mask | cut -d ':' -f2 | cut -d " " -f1)"
unixtime=$bbj"$(date +%s)"
date=$bbj"$(date)"
uptime=$bbj"$(uptime | sed s/\,//)"
kernelcmdline=$bbj"$(cat /proc/cmdline)"
id=$bbj"$(id)"
kcrypto=$bbj"$(cat /proc/crypto | grep name | cut -d':' -f2 | uniq | tr -s '\n' ' '|sed s/\,//)"
version=$bbj"$(cat /proc/version)"
memstat=$bbj"$(cat /proc/meminfo | head -n 3 | tr -s '\n' ' ')"
cwd=$bbj"$(pwd)"
shell=$bbj"$(echo $SHELL)"
cmdline=$bbj"$@"
#output=$bbj"$($cmdline)"
output=`busybox jshon -s "$($@)"`
getstty=$bbj"$(stty)"
term=$bbj"$(echo $TERM)"
cpuname=$bbj"$(cat /proc/cpuinfo | grep name)"

echo '{
"ip" : "'$ip'",
"unixtime": "'$unixtime'",
"date": "'$date'",
"uptime" : "'$uptime'",
"cpuname": "'$cpuname'",
"memstat" : "'$memstat'",
"id" : "'$id'",
"version" : "'$version'",
"kernel_cmdline": "'$kernelcmdline'",
"kernel_crypto": "'$kcrypto'",
"shell": "'$shell'",
"term": "'$term'",
"stty": "'$getstty'",
"cwd": "'$cwd'",
"cmdline": "'$cmdline'",
"output": '$output'
}'



