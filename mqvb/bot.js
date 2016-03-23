#!/usr/bin/env node

var sqlite3 = require('sqlite3').verbose();
var irc = require('irc');

//set up the db file
var db = new sqlite3.Database('ddos.db');
//set up irc connection
var bot = new irc.Client('localhost', 'ddosbot', {
    debug: true,
    channels: ['#ddos']
});
//error listener
bot.addListener('error', function(message) {
    console.error('ERROR: %s: %s', message.command, message.args.join(' '));
});
//log channel to console
bot.addListener('message#ddos', function(from, message) {
    console.log('<%s> %s', from, message);
});
//cmds
bot.addListener('message', function(from, to, message) {
    console.log('%s => %s: %s', from, to, message);
//hello world
    if (to.match(/^[#&]/)) {
        // channel message
        if (message.match(/hello/i)) {
            bot.say(to, 'Hello there ' + from);
        }
//settimeout example
//        if (message.match(/dance/)) {
 //           setTimeout(function() { bot.say(to, '\u0001ACTION dances: :D\\-<\u0001'); }, 1000);
  //          setTimeout(function() { bot.say(to, '\u0001ACTION dances: :D|-<\u0001');  }, 2000);
   //         setTimeout(function() { bot.say(to, '\u0001ACTION dances: :D/-<\u0001');  }, 3000);
    //        setTimeout(function() { bot.say(to, '\u0001ACTION dances: :D|-<\u0001');  }, 4000);
     //   }
    }
    else {
        // private message
        console.log('private message');
    }
});
bot.addListener('pm', function(nick, message) {
    console.log('Got private message from %s: %s', nick, message);
});
bot.addListener('join', function(channel, who) {
    console.log('%s has joined %s', who, channel);
});
bot.addListener('part', function(channel, who, reason) {
    console.log('%s has left %s: %s', who, channel, reason);
});
bot.addListener('kick', function(channel, who, by, reason) {
    console.log('%s was kicked from %s by %s: %s', who, channel, by, reason);
});

//example sql
//db.serialize(function() {
//  db.run("CREATE TABLE lorem (info TEXT)");
//
//  var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
//  for (var i = 0; i < 10; i++) {
//      stmt.run("Ipsum " + i);
//  }
//  stmt.finalize();
//
//  db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
//      console.log(row.id + ": " + row.info);
//  });
//});
//db.close();


