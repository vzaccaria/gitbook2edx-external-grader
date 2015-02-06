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

    port   = get-option('-p', '--port', 1666, o)
    code   = o['CODE']
    engine = get-option('-e', '--engine', 'node', o)
    dry    = get-option('-d', '--dry', false, o)

    if o['run'] 
        return { serve: false, run: true, code: code, engine: engine, dry: dry }
    else
        return { serve: true, run: false, port: port }

main = ->
    { serve, run } = get-options!
    if serve 
        { port } = get-options!
        server.bringup(port)
    else 
        { code, engine, dry } = get-options!
        if dry 
            require('./lib/codejail').dry.run(engine, code)
        else
            require('./lib/codejail').common.run(engine, code)


main!





