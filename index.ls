{docopt} = require('docopt')
require! 'fs'

shelljs = require('shelljs')
server  = require('./lib/server')
config  = require('./lib/config')

exec = require('bluebird').promisify(shelljs.exec)

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
    engine = get-option('-e', '--engine', 'javascript', o)
    dry    = get-option('-d', '--dry', false, o)

    if o['run']
        return { serve: false, run: true, code: code, engine: engine, dry: dry, +verbose }
    else
        return { serve: true, run: false, port: port , -verbose}

configure-server-dependencies = ->
    { configure } = require('./lib/das')
    configure({
            'fs': 'fs'
            'shelljs': 'shelljs'
            'os': 'os'
            'uid': 'uid'
    })

configure-cli-dependencies = (is-it-dry) ->
    { configure } = require('./lib/das')

    dryWrite = (name, content, mode, callback) ->
                        console.log "Writing to #name: #content"
                        callback(null, 'ok')

    dryExec = (command, opts, callback) ->
        console.log "Executing: #command"
        callback(0, 'ok')

    if is-it-dry
        if require('os').platform() != 'darwin'
            configure({
                'fs': { writeFile: dryWrite }
                'shelljs': { exec: dryExec }
                'os': 'os'
                'uid': 'uid'
            })
        else
            configure({
                'fs': { writeFile: dryWrite }
                'shelljs': { exec: dryExec }
                'os': { tmpdir: -> "faketmp" }
                'uid': -> 'fakeuid'
            })
    else
        configure({
            'fs': 'fs'
            'shelljs': 'shelljs'
            'os': 'os'
            'uid': 'uid'
        })

main = ->
    # Main program configuration
    config.set(get-options!)

    # Parse commands
    { serve, run } = get-options!
    if serve
        { port } = get-options!
        configure-server-dependencies()
        server.bringup(port)

    else
        { code, engine, dry } = get-options!
        configure-cli-dependencies(dry)
        require('./lib/codejail').run(engine, code).then ->
          if it.success? and it.success
            process.exit(0)
          else
            process.exit(1)


main!
