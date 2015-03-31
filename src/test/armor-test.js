var expect = require('chai').expect
  // var cj = require('./codejail')
var Promise = require('bluebird')
var _ = require('lodash')
var path = require('path')


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

var testVectors = [{
  type: 'javascript',
  code: '(code)',
  output: 'output',
  message: 'test message',
  platform: 'all'
}]

var projDir = path.join(__dirname, "../../")

function runCommand(t) {
  "use strict"
  return new Promise(function (resolve, reject) {
    require('shelljs').exec(projDir + "/index.js run -e " + t.type + " '" + t.code + "'", {
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

/* global it, describe, os */

describe("#codejail", function () {
  "use strict"
  _.map(testVectors, function (t) {
    if (os.platform() === 'all' || os.platform() === t.platform) {
      it(t.message + " should work", function () {
        runCommand(t).should.eventually.be.equal(t.output)
      })
    }
  })
})