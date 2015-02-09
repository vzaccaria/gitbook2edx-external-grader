_               = require('lodash')
moment          = require 'moment'
fs              = require 'fs'
$               = require 'bluebird'
__              = require 'shelljs'

debug = require('debug')('fakelang')

exec = $.promisify(__.exec)

_module = ->

    grade = (response, payload) -> 
        payload.context ?= ""
        payload.valudation ?= ""
        program = """
            #{payload.context}
            #{response}
            #{payload.validation}
        """
        try 
            if payload.validation == "bombit"
                throw "Ouch!"
            result = program
        catch 
            return { -correct, score: 0, msg: "noo! it failed"}

        return { +correct, score: 1, msg: program }
          
    iface = { 
        grade: grade
    }
  
    return iface
 
module.exports = _module()

