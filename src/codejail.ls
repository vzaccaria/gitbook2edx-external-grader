"use strict"

{ required } = require('./das')

_module = (_, moment, fs, $, __, co, debug, uid, os) ->
    ->
        cmd        = -> $.promisify(__.exec)(it, {+async})
        writeAsync = $.promisify(fs.writeFile)
        commands   = {}
        temp-dir   = os.tmpdir()

        { deploy-profile, run-profile, remove-profile } = require './armor'

        default_limits = {
            cpu:      1 # 1 second cpu-time
            realtime: 1 # 1 second wall-time
            fsize:    0 # number of files that can be created
        }

        setLimits = ->
            default_limits := _.assign(default_limits, it)

        configure = (command, binary_path, profile, user) ->

            commands[command] = {
                cmdline_start: "#binary_path"
                user: user
                profile: profile
                }

        jail_code = (engine, code, argv, files, stdin) ->
            co ->* 
                command     = ""
                sandbox-dir = "#temp-dir/#{uid(8)}"

                yield cmd("mkdir -p #sandbox-dir")

                command     = command + "SANDBOXDIR=#sandbox-dir "

                yield _.mapValues files, (content, name) ->
                    writeAsync("#sandbox-dir/#name", content, 'utf-8')

                yield deploy-profile("#sandbox-dir/profile.aa", commands[engine].profile("#sandbox-dir/jailed.code"))

                code := "\#!#{commands[engine].cmdline_start}\n" + code

                yield writeAsync("#sandbox-dir/jailed.code", code, 'utf-8')
                yield cmd("chmod +x #sandbox-dir/jailed.code")
		

                user = commands[engine].user
                command = command + run-profile(user, "#sandbox-dir/profile.aa", "#sandbox-dir/jailed.code")

                var result
                var success
                try
                    result := yield cmd(command)
                    success := true
                catch 
                    result := e 
                    success := false 

                yield remove-profile "#sandbox-dir/profile.aa"
                yield cmd("rm -rf #sandbox-dir")    
                return { success, result }
            .catch ->
                return { -success, result: 'internal error' }	
		

        configure-all = ->
            profiles = require('./profiles')
            for name, value of profiles
                configure(name, value.path, value.aa, value.user)

        simply-run = (engine, code) ->
            configure-all('run-sandbox')
            profiles = require('./profiles')

            if not profiles[engine]?
                throw "Sorry, no current profile for #engine"

            return jail_code(engine, code, "", {},  "")
                 
              
        iface = { 
            configure: configure
            jail_code: jail_code
            run: simply-run
            configure-all: configure-all
        }
      
        return iface
 
module.exports = _module(
    require('lodash')
    require 'moment'
    required! 'fs' 
    require 'bluebird'
    required! 'shelljs'
    require 'co'
    require('debug')('codejail')
    required! 'uid'
    required! 'os'
    )()



