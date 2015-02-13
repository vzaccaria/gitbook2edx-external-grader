"use strict"

{ required } = require('./das')

config = require('./config')

_module = (_, moment, fs, $, __, co, debug, uid, os) ->
    ->
        cmd        = -> 
            $.promisify(__.exec)(it, {+async, silent: (not config.get!.verbose) })
        writeAsync = $.promisify(fs.writeFile)
        temp-dir   = os.tmpdir()

        { deploy-profile, run-profile, remove-profile } = require './armor'

        default_limits = {
            cpu:      1 # 1 second cpu-time
            realtime: 1 # 1 second wall-time
            fsize:    0 # number of files that can be created
        }

        setLimits = ->
            default_limits := _.assign(default_limits, it)

        jail_code = (engine, code, argv, files, stdin) ->
            co ->* 
                profile = require('./profiles')[engine]

                if not profile?
                    throw "Sorry, non existing profile"

                command     = ""
                sandbox-dir = "#temp-dir/#{uid(8)}"

                yield cmd("mkdir -p #sandbox-dir")

                config-options = {
                    program-name: "#sandbox-dir/jailed.code"
                    folder-name: "#sandbox-dir"
                    }

                command     = command + "SANDBOXDIR=#sandbox-dir "

                debug profile
                
                if profile.env?
                    command = command + " #{profile.env(config-options)} "


                yield _.mapValues files, (content, name) ->
                    writeAsync("#sandbox-dir/#name", content, 'utf-8')

                debug "Writing profile"
                aa-profile-content = profile.aa("#sandbox-dir/jailed.code", config-options)

                debug aa-profile-content
                
                yield deploy-profile("#sandbox-dir/profile.aa", aa-profile-content)

                code := "\#!#{profile.path}\n" + code

                yield writeAsync("#sandbox-dir/jailed.code", code, 'utf-8')
                yield cmd("chmod +x #sandbox-dir/jailed.code")
		

                user = profile.user
                command = command + run-profile(user, "#sandbox-dir/profile.aa", "#sandbox-dir/jailed.code")

                debug command 

                var result
                var success
                try
                    result := yield cmd(command)
                    debug result
                    success := true
                catch 
                    result := e 
                    debug result
                    success := false 

                yield remove-profile "#sandbox-dir/profile.aa"
                yield cmd("rm -rf #sandbox-dir")    
                return { success, result }
            .catch ->
                return { -success, result: 'internal error' }	

        simply-run = (engine, code) ->
            profiles = require('./profiles')

            if not profiles[engine]?
                throw "Sorry, no current profile for #engine"

            return jail_code(engine, code, "", {},  "")
                 
        # configure-all!

        iface = { 
            jail_code: jail_code
            run: simply-run
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



