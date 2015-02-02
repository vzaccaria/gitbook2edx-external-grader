
_               = require('lodash')
moment          = require 'moment'
fs              = require 'fs'
$               = require 'bluebird'
__              = require 'shelljs'

debug = require('debug')('grader')




_module = ->

    grade = (payload) ->
        if payload.lang?
                grader-api = require "./lang/#{payload.lang}"
                return grader-api.grade(payload)
        else
            throw "Sorry, you need to specify a valid grader."
          
    iface = { 
        grade: grade
    }
  
    return iface
 
module.exports = _module()

