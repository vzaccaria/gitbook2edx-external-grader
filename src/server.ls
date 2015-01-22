"use strict"

_      = require('lodash')
moment = require 'moment'
fs     = require 'fs'
$      = require 'bluebird'
__     = require 'shelljs'
koa    = require 'koa'

debug = require('debug')('server')

_module = ->
    var app

    bringup = (port) ->
        app := koa()

        debug "koa registered"

        app.use ->* 
            debug "request received"
            if @method != 'POST'
                @throw 404, 'sorry, only post methods allowed'
            else 
                try 
                    { student_response, grader_payload } = yield parse(@, {limit: '1kb'})
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

