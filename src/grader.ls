"use strict"

debug = require('debug')('grader')

_module = ->

    debug "Started"

    grade = (response, payload) ->*
        debug "Response: "
        debug response 
        debug "Payload"
        debug payload
        if payload.lang?
                grader-api = require "./lang/#{payload.lang}"
                return grader-api.grade(response, payload)
        else
            throw "Sorry, you must specify a language"
          
    iface = { 
        grade: grade
    }
  
    return iface

module.exports = _module!

