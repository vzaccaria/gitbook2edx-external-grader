"use strict"

_module = (_, moment, fs, $, __, koa, co-body, b64, debug, grader) ->
    var app
    debug     = debug 'server'
    { grade } = grader
    create = ->
        app := koa()

        parse = co-body

        debug "koa registered"

        app.use ->* 
            debug "request received"
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
                    debug data.grader_payload
                    grader-response = yield grade(data.student_response, data.grader_payload)
                    @body = grader-response
                catch 
                    debug(e)
                    @response.status = 406
                    @response.body = { message: e }

        debug "koa post method registered"
        return app

    bringup = (port) ->
        debug "listening on: http://localhost:#port"
        return create!.listen(port)

    iface = { 
        create: create
        bringup: bringup
    }
  
    return iface

module.exports = _module(
    require('lodash'), 
    require('moment'), 
    require('fs'), 
    require('bluebird'), 
    require('shelljs'), 
    require('koa'), 
    require('co-body'), 
    require('base64-url'), 
    require('debug'), 
    require('./grader') 
    )



#-> require! { './grader': {mocked} }


