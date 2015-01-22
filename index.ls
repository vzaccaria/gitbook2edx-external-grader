
{docopt} = require('docopt')
require! 'fs'

shelljs = require('shelljs')
server  = require('./lib/server')

get-options = ->
    doc = shelljs.cat(__dirname+"/docs/usage.md")

    get-option = (a, b, def, o) ->
        if not o[a] and not o[b]
            return def
        else 
            return o[b]

    o = docopt(doc)

    port = get-option('-p', '--port', 1666, o)
    return { port }

main = ->
    { port } = get-options!
    server.bringup(port)


main!





