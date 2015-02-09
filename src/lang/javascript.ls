_               = require('lodash')
moment          = require 'moment'
fs              = require 'fs'
$               = require 'bluebird'
__              = require 'shelljs'

debug = require('debug')('javascript')

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
            debug(program)
            result = program
        catch 
            return { -correct, score: 0, msg: "noo! try again." }

        return { +correct, score: 1, msg: "ok!" }
          
    iface = { 
        grade: grade
    }
  
    return iface
 
module.exports = _module()

