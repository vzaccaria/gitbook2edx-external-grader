// Generated by LiveScript 1.3.1
(function(){
  "use strict";
  var _module, mfs, mshelljs, mos, fakeuid;
  _module = function(_, moment, fs, $, __, co, debug, uid, os){
    return function(){
      var cmd, writeAsync, commands, tempDir, default_limits, setLimits, configure, jail_code, configureAll, simplyRun, iface;
      cmd = function(it){
        return $.promisify(__.exec)(it, {
          async: true
        });
      };
      writeAsync = $.promisify(fs.writeFile);
      commands = {};
      tempDir = os.tmpdir();
      default_limits = {
        cpu: 1,
        realtime: 1,
        fsize: 0
      };
      setLimits = function(it){
        return default_limits = _.assign(default_limits, it);
      };
      configure = function(command, binary_path, profile, user){
        return commands[command] = {
          cmdline_start: binary_path + "",
          user: user,
          profile: profile
        };
      };
      jail_code = function(engine, code, argv, files, stdin){
        return co(function*(){
          var command, sandboxDir, result, user, output;
          command = "";
          sandboxDir = tempDir + "/" + uid(8);
          result = yield cmd("mkdir -p " + sandboxDir);
          command = command + ("SANDBOXDIR=" + sandboxDir + " ");
          yield _.mapValues(files, function(content, name){
            return writeAsync(sandboxDir + "/" + name, content, 'utf-8');
          });
          yield writeAsync(sandboxDir + "/profile.aa", commands[engine].profile, 'utf-8');
          code = ("#!" + commands[engine].cmdline_start + "\n") + code;
          yield writeAsync(sandboxDir + "/jailed.code", code, 'utf-8');
          yield cmd("chmod +x " + sandboxDir + "/jailed.code");
          user = commands[engine].user;
          if (user != null) {
            command = command + ("sudo -u " + user + " ");
          } else {
            command = command + "sudo ";
          }
          command = command + ("aa-exec -p " + sandboxDir + "/profile.aa " + sandboxDir + "/jailed.code");
          output = yield cmd(command);
          yield cmd("rm -rf " + sandboxDir);
          return output;
        });
      };
      configureAll = function(){
        var profiles, name, value, results$ = [];
        profiles = require('./profiles');
        for (name in profiles) {
          value = profiles[name];
          results$.push(configure(name, value.path, value.aa, value.user));
        }
        return results$;
      };
      simplyRun = function(engine, code){
        var profiles;
        configureAll('run-sandbox');
        profiles = require('./profiles');
        if (profiles[engine] == null) {
          throw "Sorry, no current profile for " + engine;
        }
        return jail_code(engine, code, "", {}, "");
      };
      iface = {
        configure: configure,
        jail_code: jail_code,
        run: simplyRun,
        configureAll: configureAll
      };
      return iface;
    };
  };
  module.exports.common = _module(require('lodash'), require('moment'), require('fs'), require('bluebird'), require('shelljs'), require('co'), require('debug')('codejail'), require('uid'), require('os'))();
  mfs = {};
  mshelljs = {};
  mos = {};
  mfs.writeFile = function(name, content, mode, callback){
    console.log("Writing to " + name + ": " + content);
    return callback(null, 'ok');
  };
  mshelljs.exec = function(command, opts, callback){
    console.log("Executing: " + command);
    return callback(0, 'ok');
  };
  mos.tmpdir = function(){
    return "/fake/tmp";
  };
  fakeuid = function(){
    return "fakeuid";
  };
  module.exports.mocked = _module(require('lodash'), require('moment'), mfs, require('bluebird'), mshelljs, require('co'), require('debug')('codejail'), fakeuid, mos)();
  module.exports.dry = _module(require('lodash'), require('moment'), mfs, require('bluebird'), mshelljs, require('co'), require('debug')('codejail'), require('uid'), require('os'))();
}).call(this);