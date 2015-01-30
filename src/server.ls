"use strict"

_      = require('lodash')
moment = require 'moment'
fs     = require 'fs'
$      = require 'bluebird'
__     = require 'shelljs'
koa    = require 'koa'
parse = require 'co-body'
b64 = require('base64-url')

debug = require('debug')('server')

_module = ->
    var app

    bringup = (port) ->
        app := koa()

        debug "koa registered"

        app.use ->* 
            debug "request received"
            console.log @
            if @method != 'POST'
                @throw 404, 'sorry, only POST methods allowed'
            else 
                try 
                    data = {}
                    req = (yield parse.json(@.req))
                    semi = JSON.parse(req.xqueue_body)
                    data.student_info = JSON.parse(semi.student_info)
                    data.student_response = semi.student_response
                    data.grader_payload = JSON.parse(semi.grader_payload).payload
                    data.grader_payload = b64.decode(data.grader_payload)
                    data.grader_payload = JSON.parse(data.grader_payload)
                    console.log JSON.stringify(semi, 0, 4)
                    console.log JSON.stringify(data, 0, 4)
                    /* launch grader */
                    @body = { correct: false, score: 0, msg: "sample msg"}
                catch
                    @throw(404, 'invalid request')

        debug "koa post method registered"
        app.listen(port)
        debug "listening on: http://localhost:#port"

    iface = { 
        bringup: bringup
    }
  
    return iface
 
module.exports = _module()

