var chai = require('chai')
chai.use(require('chai-as-promised'))
var should = chai.should()

// var cj = require('./codejail')
var Promise = require('bluebird')
var _ = require('lodash')
var path = require('path')
var os = require('os')


// function buildMocks(argument) {
//   var configure = require('./das');
//   var mfs = {}
//   var mshelljs = {}
//   var mos = {}
//
//   mfs.writeFile = function writeFile(name, content, mode, callback) {
//     callback(null, 'ok')
//   }
//
//   mshelljs.exec = function exec(command, opts, callback) {
//     callback(0, 'ok')
//   }
//
//   mos.tmpdir = function tmpdir() {
//     return "/fake/tmp"
//   }
//
//   function fakeuid() {
//     return "fakeuid"
//   }
//
//   configure({
//     'fs': mfs,
//     'shelljs': mshelljs,
//     'os': mos,
//     'uid': fakeuid
//   })
// }

var darwinTest = require('./fix.js').darwin

var testVectors = [{
  type: 'javascript',
  code: 'var x=1',
  output: darwinTest.test1,
  opts: '-d',
  message: 'dry run test, without app-armor',
  platform: 'all'
}, {
  type: 'javascript',
  code: 'console.log("ciao")',
  output: 'ciao\n',
  message: 'wet run test, without app-armor',
  platform: 'all'
}]

var projDir = path.join(__dirname, "../../")

function runCommand(t) {
  "use strict"
  return new Promise(function (resolve, reject) {
    var cmd = projDir + "index.js run -e " + t.type + " '" + t.code + "' " + (t.opts || '')
    require('shelljs').exec(cmd, {
      async: true,
      silent: true
    }, function (code, output) {
      if (code !== 0) {
        reject(output)
      } else {
        resolve(output)
      }
    })
  })
}

/* global it, describe */

describe("#codejail", function () {
  "use strict"
  _.each(testVectors, function (t) {
    it(t.message + " should work on " + t.platform, function () {
      return runCommand(t).should.eventually.equal(t.output)
    })
  })
})