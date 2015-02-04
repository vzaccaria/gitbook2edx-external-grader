#!/usr/local/bin/node --harmony
// Generated by LiveScript 1.3.1
(function(){
  var docopt, fs, shelljs, server, getOptions, main;
  docopt = require('docopt').docopt;
  fs = require('fs');
  shelljs = require('shelljs');
  server = require('./lib/server');
  getOptions = function(){
    var doc, getOption, o, port, code, engine, dry;
    doc = shelljs.cat(__dirname + "/docs/usage.md");
    getOption = function(a, b, def, o){
      if (!o[a] && !o[b]) {
        return def;
      } else {
        return o[b];
      }
    };
    o = docopt(doc);
    port = getOption('-p', '--port', 1666, o);
    code = o['CODE'];
    engine = getOption('-e', '--engine', 'node', o);
    dry = getOption('-d', '--dry', false, o);
    if (o['run']) {
      return {
        serve: false,
        run: true,
        code: code,
        engine: engine,
        dry: dry
      };
    } else {
      return {
        serve: true,
        run: false,
        port: port
      };
    }
  };
  main = function(){
    var ref$, serve, run, port, code, engine, dry;
    ref$ = getOptions(), serve = ref$.serve, run = ref$.run;
    if (serve) {
      port = getOptions().port;
      return server.bringup(port);
    } else {
      ref$ = getOptions(), code = ref$.code, engine = ref$.engine, dry = ref$.dry;
      if (dry) {
        return require('./lib/codejail').dry.run(engine, code);
      } else {
        return require('./lib/codejail').common.run(engine, code);
      }
    }
  };
  main();
}).call(this);
