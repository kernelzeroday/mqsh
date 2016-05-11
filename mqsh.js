// Generated by CoffeeScript 1.10.0
(function() {
  var Corporal, argv, base64_encode, base64str, basesixfourdecode, basesixfourencode, btchost, btcport, btcpw, btcrpc, btcuser, client, colors, corporal, decryptkey, defenc, exec, fs, mqpasswd, mqtt, mquser, pubtopic, readcommand, rpcpassword, rpcuser, servername, shell, startinteractive, subtopic;

  mqtt = require('mqtt');

  Corporal = require('corporal');

  colors = require('colors/safe');

  readcommand = require('readcommand');

  argv = require('optimist').argv;

  fs = require('fs');

  exec = require('child_process').exec;

  decryptkey = "lol";

  fs = require('fs');

  base64_encode = function(file) {
    var bitmap;
    bitmap = fs.readFileSync(file);
    return new Buffer(bitmap).toString('base64');
  };

  shell = function() {
    var client, sigints;
    client = mqtt.connect('mqtt://' + servername, {
      'username': mquser,
      'password': mqpasswd
    });
    console.log('mqtt.connect ' + servername);
    client.on('connect', function() {
      client.subscribe(subtopic);
    });
    client.on('message', function(topic, message) {
      var bsfmes;
      if (basesixfourdecode === 1) {
        console.log(colors.yellow(new Buffer(message.toString(), 'base64').toString('ascii')));
      }
      if (defenc === 1) {
        bsfmes = message.toString('ascii');
        fs.writeFile("/tmp/buffmess", bsfmes.replace('\n', ''), function(err) {
          if (err) {
            throw err;
          }
          return exec("cat /tmp/buffmess | base64 -d| busybox fenc d '!" + decryptkey + "'", function(err, stdout, stderr) {
            if (err) {
              console.log(err);
            }
            return console.log(colors.blue(new Buffer(stdout.toString(), 'base64').toString('ascii')));
          });
        });
      } else {
        console.log(colors.yellow(message));
      }
    });
    sigints = 0;
    readcommand.loop(function(err, args, str, next) {
      var sendme;
      if (err && err.code !== 'SIGINT') {
        throw err;
      } else if (err) {
        if (sigints === 1) {
          process.exit(0);
        } else {
          sigints++;
          console.log('Press ^C again to exit.');
          return next();
        }
      } else {
        sigints = 0;
      }
      if (basesixfourencode === true) {
        sendme = new Buffer(args.join(' ')).toString('base64');
        client.publish(pubtopic, sendme);
      } else {
        client.publish(pubtopic, args.join(' '));
      }
      return next();
    });
  };

  btcrpc = function() {
    var sigints;
    console.log('rpc start...');
    sigints = 0;
    readcommand.loop(function(err, args, str, next) {
      if (err && err.code !== 'SIGINT') {
        throw err;
      } else if (err) {
        if (sigints === 1) {
          process.exit(0);
        } else {
          sigints++;
          console.log('Press ^C again to exit.');
          return next();
        }
      } else {
        sigints = 0;
      }
      colors.yellow(exec('bitcoin-cli -regtest -rpcuser=' + rpcuser + ' -rpcpassword=' + rpcpassword + ' ' + args.join(' ')).stdout);
      return next();
    });
  };

  startinteractive = function() {
    corporal.on('load', corporal.loop);
  };

  require('shelljs/global');

  mqpasswd = 'test';

  mquser = 'test';

  basesixfourdecode = 0;

  basesixfourencode = false;

  defenc = 0;

  btchost = 'localhost';

  btcport = '18332';

  btcuser = 'user';

  btcpw = 'password';

  corporal = new Corporal({
    'commands': {
      'sh': {
        'description': 'open shell',
        'invoke': function(session, args, callback) {
          console.log(colors.blue(' [*] ') + colors.red('opening mqtt shell on ') + colors.green(servername));
          shell();
        }
      },
      'echo': {
        'description': 'echo',
        'invoke': function(session, args, callback) {
          session.stdout().write(args[0] + '\n');
          callback();
        }
      },
      'server': {
        'description': 'current server',
        'invoke': function(session, args, callback) {
          console.log(servername);
          callback();
        }
      },
      'subtopic': {
        'description': 'current subscription topic',
        'invoke': function(session, args, callback) {
          console.log(subtopic);
          callback();
        }
      },
      'pubtopic': {
        'description': 'current publish topic',
        'invoke': function(session, args, callback) {
          console.log(pubtopic);
          callback();
        }
      },
      'connect': {
        'description': 'connect to current server',
        'invoke': function(session, args, callback) {
          console.log(servername);
          startlistener();
          callback();
        }
      },
      'chpub': {
        'description': 'change pubtopic',
        'invoke': function(session, args, callback) {
          var pubtopic;
          console.log(colors.yellow('changing publish topic to ') + colors.magenta(args));
          pubtopic = args;
          callback();
        }
      },
      'chsub': {
        'description': 'change subtopic',
        'invoke': function(session, args, callback) {
          var subtopic;
          console.log(colors.yellow('changing subscription topic to ') + colors.magenta(args));
          subtopic = args;
          callback();
        }
      },
      'chserv': {
        'description': 'change mqtt server',
        'invoke': function(session, args, callback) {
          var servername;
          console.log(colors.yellow('changing mqtt server to ') + colors.magenta(args));
          servername = args;
          callback();
        }
      },
      'rpc': {
        'description': 'call bitcoin rpc shell',
        'invoke': function(session, args, callback) {
          btcrpc();
        }
      }
    }
  });

  subtopic = 'data';

  pubtopic = 'shell';

  servername = 'localhost';

  if (argv.h) {
    servername = argv.h;
  }

  if (argv.b) {
    basesixfourdecode = 1;
  }

  if (argv.k) {
    basesixfourencode = true;
  }

  if (argv.p) {
    pubtopic = argv.p;
  }

  if (argv.t) {
    subtopic = argv.t;
  }

  if (argv.s) {
    shell();
  }

  if (argv.j) {
    btchost = argv.j;
  }

  if (argv.q) {
    btcpw = argv.q;
  }

  if (argv.e) {
    btcuser = argv.e;
  }

  if (argv.n) {
    btcport = argv.n;
  }

  if (argv.r) {
    btcrpc();
  }

  if (argv.u) {
    mquser = argv.u;
  }

  if (argv.m) {
    mqpasswd = argv.m;
  }

  if (argv.a) {
    defenc = 1;
  }

  if (argv.U) {
    base64str = base64_encode(argv.U);
    console.log(base64str);
    client = mqtt.connect('mqtt://' + servername);
    console.log('mqtt.connect ' + servername);
    client.publish(pubtopic, '_binary_' + ' ' + argv.U + ' ' + base64str);
    exit;
  }

  if (argv.e) {
    rpcuser = argv.e;
  }

  if (argv.q) {
    rpcpassword = argv.q;
  }

  if (argv.i) {
    console.log('welcome to mqsh type help to begin');
    startinteractive();
  }

}).call(this);
