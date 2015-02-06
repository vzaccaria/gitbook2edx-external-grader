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

    create = ->
        app := koa()

        debug "koa registered"

        app.use ->* 
            debug "request received"
            if @method != 'POST'
                @throw 404, 'sorry, only POST methods allowed'
            else 
                try 
                    data = {}
                    req = (yield parse.json(@.req))
                    debug(req)
                    semi = JSON.parse(req.xqueue_body)
                    debug semi
                    data.student_info = JSON.parse(semi.student_info)
                    data.student_response = semi.student_response
                    data.grader_payload = JSON.parse(semi.grader_payload).payload
                    debug data.grader_payload
                    data.grader_payload = b64.decode(data.grader_payload)
                    debug data.grader_payload
                    data.grader_payload = JSON.parse(data.grader_payload)
                    /* launch grader */
                    @body = { correct: false, score: 0, msg: "sample msg"}
                catch 
                    debug(e)
                    @response.status = 406

        debug "koa post method registered"
        return app

    bringup = (port) ->
        return create!.listen(port)
        debug "listening on: http://localhost:#port"

    iface = { 
        create: create
        bringup: bringup
    }
  
    return iface
 
module.exports = _module()

