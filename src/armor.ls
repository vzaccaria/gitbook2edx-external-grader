
"use strict"

{ required } = require('./das')

fs = required! 'fs'
__ = required! 'shelljs'
os = require 'os'

$          = require('bluebird')
cmd        = -> $.promisify(__.exec)(it, {+async})
writeAsync = $.promisify(fs.writeFile)
co         = require 'co'


debug = require('debug')('edx:armor')

_module = ->

    cmd        = -> $.promisify(__.exec)(it, {+async})
    writeAsync = $.promisify(fs.writeFile)

    deploy-profile = (profile-path, profile) ->
        if os.platform() == 'linux'
            (co ->*
                yield writeAsync(profile-path, profile, 'utf-8')
                yield cmd("sudo apparmor_parser -a #profile-path"))
        else
            co ->*
                yield writeAsync(profile-path, profile, 'utf-8')



    run-profile = (user, profile-path, script) ->
        if os.platform() == 'linux'
            pre = ""
            if user?
                pre := "sudo -u #user"
            else
                pre := "sudo"
            return "#pre aa-exec -f #profile-path #script"
        else
            return script

    remove-profile = (profile-path) ->
        if os.platform() == 'linux'
            (co ->*
                yield cmd("sudo apparmor_parser -R #profile-path"))
        else
            co ->* true


    iface = {
        deploy-profile: deploy-profile
        run-profile: run-profile
        remove-profile: remove-profile
    }

    return iface

module.exports = _module()
