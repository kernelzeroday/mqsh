#mqsh.js
# depends on mqtt, colors, readcommand, corporal
# async shell for infinite number of clients
# todo: fix things, hacky v1 beta release, bad argument option handling
#	- also	need to add file transfer function for bbn update?
# 		~ kod ~
#
#
#HOW TO INSTALL:   $ mkdir mqsh; mv mqsh.js mqsh; cd mqsh; npm install optimist; npm install mqtt; npm install corporal; npm install colors; npm install readcommand; echo done; nodejs mqsh.js localhost
#var sleep = require('sleep');
# set up our dependancies
mqtt = require('mqtt')
Corporal = require('corporal')
colors = require('colors/safe')
readcommand = require('readcommand')
argv = require('optimist').argv
fs = require('fs')
aexec = require('child_process').aexec
decryptkey = "lol"
fs = require('fs')
#var bitcoin = require('bitcoin');
# function to encode file data to base64 encoded string
base64_encode = (file) ->
  # read binary data
  bitmap = fs.readFileSync(file)
  # convert binary data to base64 encoded string
  new Buffer(bitmap).toString 'base64'

#function for beginning a mqtt connection to a server, listening to topic defined by subtopic and publishing to pubtopic

shell = ->
  #this is where we connect
  client = mqtt.connect('mqtt://' + servername,
    'username': mquser
    'password': mqpasswd)
  console.log 'mqtt.connect ' + servername
  #/on client connection, we subscribe to the subtopic
  #check for base64
  #if (basesixfourdecode == 1) {
  #
  #  client.subscribe(subtopic, function() {
  #    client.on('message', function(topic, message, packet) {
  #	var fuckyou = message;
  #      console.log(fuckyou.toString('ascii'));	
  #	client.end;
  #    });
  #  });
  #} 
  #else {
  client.on 'connect', ->
    client.subscribe subtopic
    #  client.publish('lol', 'f');
    return
  #on receiving a message we write a newline and then the message
  client.on 'message', (topic, message) ->
    # message is Buffer
    #console.log("");
    if basesixfourdecode == 1
      console.log colors.yellow(new Buffer(message.toString(), 'base64').toString('ascii'))
      #  client.end();
    if defenc == 1
      epacket = new Buffer(message.toString(), 'base64').toString('ascii')
      fs.writeFile "/tmp/messagebuffer", epacket, (err) ->
        if err
          console.log err
        aexec "cat /tmp/messagebuffer | busybox fenc d '!" + decryptkey + "'", (err, stdou, stderr) ->
          if err
            console.log err
          console.log colors.blue(new Buffer(stdout.toString(), 'base64').toString('ascii'))
    else
      console.log colors.yellow(message)
    return
  #}
  #for handling control c
  sigints = 0
  readcommand.loop (err, args, str, next) ->
    if err and err.code != 'SIGINT'
      throw err
    else if err
      if sigints == 1
        #	callback();
        process.exit 0
      else
        sigints++
        console.log 'Press ^C again to exit.'
        return next()
    else
      sigints = 0
    # handle the input and send to pubtopic
    #console.log('Received args: %s', JSON.stringify(args));
    if basesixfourencode is true
      sendme = new Buffer(args.join(' ')).toString('base64')

      client.publish pubtopic, sendme
    else
      client.publish pubtopic, args.join(' ')
    next()
  return

btcrpc = ->
  console.log 'rpc start...'
  #for handling control c
  sigints = 0
  readcommand.loop (err, args, str, next) ->
    if err and err.code != 'SIGINT'
      throw err
    else if err
      if sigints == 1
        #	callback();
        process.exit 0
      else
        sigints++
        console.log 'Press ^C again to exit.'
        return next()
    else
      sigints = 0
    # handle the input and send to pubtopic
    #console.log('Received args: %s', JSON.stringify(args));
    #		bitrpc.cmd(args.join(" "), function(err, balance, resHeaders){
    #  if (err) return console.log(err);
    #  console.log('Balance:', balance);
    #});
    colors.yellow exec('bitcoin-cli -regtest -rpcuser=' + rpcuser + ' -rpcpassword=' + rpcpassword + ' ' + args.join(' ')).stdout
    next()
  return

#function to start tui

startinteractive = ->
  corporal.on 'load', corporal.loop
  return

require 'shelljs/global'
mqpasswd = 'test'
mquser = 'test'
basesixfourdecode = 0
basesixfourencode = false
defenc = 0
#bit rpc shell
btchost = 'localhost'
btcport = '18332'
btcuser = 'user'
btcpw = 'password'
#function to handle the initial tui
corporal = new Corporal('commands':
  'sh':
    'description': 'open shell'
    'invoke': (session, args, callback) ->
      #session.stdout().write(args[0] + '\n');
      console.log colors.blue(' [*] ') + colors.red('opening mqtt shell on ') + colors.green(servername)
      shell()
      #		callback();
      return
  'echo':
    'description': 'echo'
    'invoke': (session, args, callback) ->
      session.stdout().write args[0] + '\n'
      callback()
      return
  'server':
    'description': 'current server'
    'invoke': (session, args, callback) ->
      #session.stdout().write(args[0] + '\n');
      console.log servername
      callback()
      return
  'subtopic':
    'description': 'current subscription topic'
    'invoke': (session, args, callback) ->
      #session.stdout().write(args[0] + '\n');
      console.log subtopic
      callback()
      return
  'pubtopic':
    'description': 'current publish topic'
    'invoke': (session, args, callback) ->
      #session.stdout().write(args[0] + '\n');
      console.log pubtopic
      callback()
      return
  'connect':
    'description': 'connect to current server'
    'invoke': (session, args, callback) ->
      #session.stdout().write(args[0] + '\n');
      console.log servername
      startlistener()
      callback()
      return
  'chpub':
    'description': 'change pubtopic'
    'invoke': (session, args, callback) ->
      console.log colors.yellow('changing publish topic to ') + colors.magenta(args)
      pubtopic = args
      callback()
      return
  'chsub':
    'description': 'change subtopic'
    'invoke': (session, args, callback) ->
      console.log colors.yellow('changing subscription topic to ') + colors.magenta(args)
      subtopic = args
      callback()
      return
  'chserv':
    'description': 'change mqtt server'
    'invoke': (session, args, callback) ->
      console.log colors.yellow('changing mqtt server to ') + colors.magenta(args)
      servername = args
      callback()
      return
  'rpc':
    'description': 'call bitcoin rpc shell'
    'invoke': (session, args, callback) ->
      btcrpc()
      return
)
# set up variables for use in shell data pipe
subtopic = 'data'
pubtopic = 'shell'
# take in argument from cmdline as servername for mqtt connection
servername = 'localhost'
#new style
if argv.h
  servername = argv.h
#b64
if argv.b
  basesixfourdecode = 1
if argv.k
  basesixfourencode = true
if argv.p
  pubtopic = argv.p
if argv.t
  subtopic = argv.t
if argv.s
  shell()
if argv.j
  btchost = argv.j
if argv.q
  btcpw = argv.q
if argv.e
  btcuser = argv.e
if argv.n
  btcport = argv.n
if argv.r
  btcrpc()
if argv.u
  mquser = argv.u
if argv.m
  mqpasswd = argv.m
if argv.a
  defenc = 1
if argv.U
  # convert image to base64 encoded string
  base64str = base64_encode(argv.U)
  console.log base64str
  client = mqtt.connect('mqtt://' + servername)
  console.log 'mqtt.connect ' + servername
  client.publish pubtopic, '_binary_' + ' ' + argv.U + ' ' + base64str
  exit
if argv.e
  rpcuser = argv.e
if argv.q
  rpcpassword = argv.q
if argv.i
  console.log 'welcome to mqsh type help to begin'
  startinteractive()
