var chai = require('chai')
chai.use(require('chai-as-promised'))
chai.should()

var Promise = require('bluebird')
var _ = require('lodash')
var path = require('path')
var os = require('os')


var darwinTest = require('./fix.js').darwin

var testVectors = [{
  type: 'javascript',
  code: 'var x=1',
  output: darwinTest.test1,
  opts: '-d',
  message: 'dry run test, without app-armor',
  platform: 'all',
  success: true
}, {
  type: 'javascript',
  code: 'console.log("ciao")',
  output: 'ciao\n',
  message: 'wet run test, without app-armor',
  platform: 'all',
  success: true
}, {
  type: 'javascript',
  code: 'console.log("hi!")',
  output: 'hi!\n',
  message: 'wet run test, with app-armor on Linux',
  platform: 'linux',
  success: true
}, {
  type: 'javascript',
  code: 'console.log(require("fs").readdirSync("/"))',
  output: "Error: EACCES, permission denied '/'",
  message: 'wet run test, with app-armor on Linux should fail',
  platform: 'linux',
  success: false
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

describe("#run", function () {
  "use strict"
  _.each(testVectors, function (t) {
    if (os.platform() === t.platform || t.platform === 'all') {
      it(t.message + " should work on " + t.platform, function () {
        if (t.success) {
          return runCommand(t).should.eventually.contain(t.output)
        } else {
          return runCommand(t).should.be.rejectedWith(t.output)
        }
      })
    }
  })
})

function buildMocks() {
  "use strict"
  var configure = require('../das').configure;
  var mfs = {}
  var mshelljs = {}
  var mos = {}

  mfs.writeFile = function writeFile(name, content, mode, callback) {
    callback(null, 'ok')
  }

  mshelljs.exec = function exec(command, opts, callback) {
    callback(0, 'ok')
  }

  mos.tmpdir = function tmpdir() {
    return "/fake/tmp"
  }

  function fakeuid() {
    return "fakeuid"
  }

  configure({
    'fs': mfs,
    'shelljs': mshelljs,
    'os': mos,
    'uid': fakeuid
  })
}

describe("#codejail module", function () {
  "use strict"
  it("Unit test of codejail with fake data should work", function () {
    buildMocks()
    var jailCode = require('../codejail').jail_code
    var run = require('../codejail').run
    jailCode("fake", "x+1", "p1", {
      f1: "f1",
      f2: "f2"
    }, "", "x1").then(function () {
      run("fake", "x+y+z")
    }).should.eventually.contain(darwinTest.test0)
  })
})