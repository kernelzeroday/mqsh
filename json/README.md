Json /bin/sh wrapper script for outputting shell commands as json objects for use in fancypants webdev programming or whatever

NOTE: pipes are not working for some reason. ill fix it eventually. same with semicolons, fuck, who the fuck knows why


Exmaple mqtte call:
busybox mqtte -i 127.0.0.1 -t shell -t shell/127.0.0.1 -h localhost -- /home/kod/bin/jsonsh | mosquitto_pub -t data -h localhost -l

Example mqsh output:

kod@nb:~/mqsh$ node mqsh.js -s

mqtt.connect localhost

\> whoami

\> {

"ip" : "127.0.0.1",

"unixtime": "1458775411",

"date": "Wed Mar 23 16:23:31 PDT 2016",

"uptime" : " 16:23:31 up 4 min  6 users,  load average: 0.39, 0.51, 0.24",

"memstat" : "MemTotal: 1964204 kB MemFree: 737404 kB MemAvailable: 1310408 kB ",

"openports" : "127.0.0.1:42882 users:(("ycmd",pid=3059,fd=7))!127.0.0.1:4101 !127.0.0.1:5939 !127.0.1.1:domain !127.0.0.1:ipp !127.0.0.1:postgresql !127.0.0.1:smtp !127.0.0.1:29754 !127.0.0.1:9050 !",

"id" : "uid=1000(kod) gid=1000(kod) groups=1000(kod),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),113(lpadmin),129(sambashare),130(docker),135(libvirtd)",

"version" : "Linux version 4.2.0-27-generic (buildd@lgw01-12) (gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #32-Ubuntu SMP Fri Jan 22 04:49:08 UTC 2016",

"kernel_cmdline": "BOOT_IMAGE=.vmlinuz-4.2.0-27-generic root=.dev.mapper.ubuntu--mate--vg-root ro verbose nosplash",

"kernel_crypto": " ccm(aes) ctr(aes) ecb(arc4) arc4 jitterentropy_rng stdrng xts(aes) crct10dif crc32 cbc(aes) hmac(sha256) hmac(sha1) skein1024 skein512 skein256 lzo crct10dif crc32c aes sha384 sha512 sha224 sha256 sha1 md5 crc32c ",

"cmdline" : "whoami",

"output" : "kod

"}



As you can see you get back the cmdline issued, the response as output, and a lot of other shit aswell such as execution time and kernel cmdline, memstats, a lot of shit you probably wont ever need but looks cool because we are fancy and use json. Useful for dumping into a database for analytics. Probably. 


Some shit gets mangled on purpose because I wrote this late last night. Other shit doesnt work at all, and some things work halfway. Catting a file is fucked up. Sometimes? Idk I will fix it.

A better approach foir the refactor will be to echo the format.json file instead of catting ir around into sed, I think using fs level buffers fucks shit up. For now its fine though, you can run stuff and get a response so whatever. 

Ideas for more shit to implement: 

May be wise to time all cmds and return the output as a field. 

Might be cool to do some sort of layered hierchical data output. Not sure if this is wise or not.

Need to fix openports to use netstat instead of ss cause bbn doesnt have ss
