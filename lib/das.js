// Generated by LiveScript 1.3.1
(function(){
  "use strict";
  var _, debug, configuration, configure, required, iface;
  _ = require('lodash');
  debug = require('debug')('das');
  configure = function(hashOfModuleNames){
    return configuration = _.mapValues(hashOfModuleNames, function(value, name, object){
      if (_.isString(value)) {
        return require(value);
      } else {
        return value;
      }
    });
  };
  required = function(){
    return function(it){
      return configuration[it];
    };
  };
  iface = {
    configure: configure,
    required: required
  };
  module.exports = iface;
}).call(this);