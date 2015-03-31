"use strict"

debug = require('debug')('grader')


_module = (profiles) ->

    debug "Started"

    sanitize = (response, payload) ->
        if not response?
            throw "Sorry, you should specify a response"
        payload.context ?= ""
        payload.validation ?= ""

    grade = (response, payload) ->
        sanitize(response, payload)
        var program
        debug payload
        if profiles[payload.lang]?.code?
            program := profiles[payload.lang].code(response, payload)
        else
            program := """
                #{payload.context}
                #{response}
                #{payload.validation}
            """
        debug program
        { run } = require('./codejail')
        return run(payload.lang, program)
        .then ->
            { success, result } = it
            if not success 
                { -correct, score: 0, msg: "no! output: #result", program: program }
            else
                { +correct, score: 1, msg: "ok! output: #result", program: program }

    iface = {
        grade: grade
    }

    return iface

module.exports = _module(require('./profiles'))
