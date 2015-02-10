"use strict"

_module = (_, debug) ->

    debug = debug('grader')

    grade = (response, payload) ->*
        if payload.lang?
                grader-api = require "./lang/#{payload.lang}"
                return grader-api.grade(response, payload)
        else
            throw "Sorry, #{payload.lang} is invalid"
          
    iface = { 
        grade: grade
    }
  
    return iface

module.exports = _module(
    require("lodash"),
    require("debug")
    )

