# mqsh
controller for mqtt based shell sessions

in beta

sample use: 

kod@nb:~/mqsh$ node mqsh.js -s

mqtt.connect localhost

\> whoami

\> {
"version" : "Linux version 4.2.0-27-generic (buildd@lgw01-12) (gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #32-Ubuntu SMP Fri Jan 22 04:49:08 UTC 2016",
"date": "1458718095",
"uptime" : " 00:28:15 up  1:40,  7 users,  load average: 0.01, 0.16, 0.54",
"memstat" : "MemTotal: 1964204 kB MemFree: 629852 kB MemAvailable: 1327940 kB ",
"ip" : "127.0.0.1",
"cmdline" : "whoami",
"output" : "kod
"}

