// Generated by LiveScript 1.3.1
(function(){
  var _, moment, fs, $, __, debug, exec, _module;
  _ = require('lodash');
  moment = require('moment');
  fs = require('fs');
  $ = require('bluebird');
  __ = require('shelljs');
  debug = require('debug')('javascript');
  exec = $.promisify(__.exec);
  _module = function(){
    var grade, iface;
    grade = function(body){
      var program, result, e;
      program = "" + body.code.context + "\n" + body.student_response + "\n" + body.code.validation;
      try {
        result = eval(program);
      } catch (e$) {
        e = e$;
        return {
          correct: false,
          score: 0,
          "noo! try again.": "noo! try again."
        };
      }
      return {
        correct: true,
        score: 1,
        "ok!": "ok!"
      };
    };
    iface = {
      grade: grade
    };
    return iface;
  };
  module.exports = _module();
}).call(this);