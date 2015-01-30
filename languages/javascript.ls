_               = require('lodash')
moment          = require 'moment'
fs              = require 'fs'
$               = require 'bluebird'
__              = require 'shelljs'

debug = require('debug')('javascript')

exec = $.promisify(__.exec)

_module = ->

    grade = (body) ->* 
        program = """
            #{body.code.context}
            #{body.student_response}
            #{body.code.validation}
        """
        try 
            result = eval(program) 
        catch 
            return { -correct, score: 0, "noo! try again." }

        return { +correct, score: 1, "ok!" }
          
    iface = { 
        grade: grade
    }
  
    return iface
 
module.exports = _module()

