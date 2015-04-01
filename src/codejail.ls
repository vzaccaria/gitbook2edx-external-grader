"use strict"

{ required } = require('./das')

config = require('./config')

_module = (_, moment, fs, $, __, co, debug, uid, os) ->
    ->
        cmd        = ->
            $.promisify(__.exec)(it, {+async, silent: (not config.get!.verbose) }).then ->
                debug it
                it
        writeAsync = $.promisify(fs.writeFile)
        temp-dir   = os.tmpdir()

        { deploy-profile, run-profile, remove-profile } = require './armor'

        default_limits = {
            cpu:      1 # 1 second cpu-time
            realtime: 1 # 1 second wall-time
            fsize:    0 # number of files that can be created
        }

        build-sandbox = (files) ->*
                sandbox-dir = "#temp-dir/#{uid(8)}"

                yield cmd("mkdir -p #sandbox-dir")

                config-options = {
                    program-name: "#sandbox-dir/jailed.code"
                    folder-name: "#sandbox-dir"
                }

                yield _.mapValues files, (content, name) ->
                    writeAsync("#sandbox-dir/#name", content, 'utf-8')

                return { sandbox-dir, config-options }

        write-aa-profile = (profile, sandbox-dir, config-options) ->*
                debug "Writing profile"
                aa-profile-content = profile.aa("#sandbox-dir/jailed.code", config-options)
                debug aa-profile-content
                yield deploy-profile("#sandbox-dir/profile.aa", aa-profile-content)


        write-script = (profile, sandbox-dir, code) ->*
                code := "\#!#{profile.path}\n" + code
                debug code
                yield writeAsync("#sandbox-dir/jailed.code", code, 'utf-8')
                yield cmd("chmod +x #sandbox-dir/jailed.code")

        build-run-command = (profile, sandbox-dir, config-options) ->*
                command = "SANDBOXDIR=#sandbox-dir "
                command = command + " #{profile.env(config-options)} " if profile.env?
                command = command + run-profile(profile.user, "#sandbox-dir/profile.aa", "#sandbox-dir/jailed.code")
                debug command
                return command

        run-script = (command) ->*
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
                return { success, result }

        setLimits = ->
            default_limits := _.assign(default_limits, it)

        jail_code = (engine, code, argv, files, stdin) ->
            co ->*
                profile = require('./profiles')[engine]
                throw "Sorry, non existing profile" if not profile?

                { sandbox-dir, config-options } = yield build-sandbox(files)

                yield write-aa-profile(profile, sandbox-dir, config-options)
                yield write-script(profile, sandbox-dir, code)

                command             = yield build-run-command(profile, sandbox-dir, config-options)
                { success, result } = yield run-script(command)

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
