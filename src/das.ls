"use strict"
_     = require('lodash')
debug = require('debug')('edx:das')

var configuration

configure = (hash-of-module-names) ->
    configuration := _.mapValues hash-of-module-names, (value, name, object) ->
        if _.is-string(value)
            return require(value)
        else
            return value

required = ->
    return (it) ->
        configuration[it]

iface = {
    configure: configure
    required: required
}

module.exports = iface
