

build-mocks = ->
    { configure } = require('./das')
    mfs = {}
    mshelljs = {}
    mos = {}

    mfs.writeFile = (name, content, mode, callback) ->
        console.log "Writing to #name: #content"
        callback(null, 'ok')

    mshelljs.exec = (command, opts, callback) ->
        console.log "Executing: #command"
        callback(0, 'ok')

    mos.tmpdir = ->
        return "/fake/tmp"

    fakeuid = ->
        return "fakeuid"

    configure({
            'fs': mfs
            'shelljs': mshelljs
            'os': mos
            'uid': fakeuid
    })

run-tests = ->
    { jail_code, run, configure-all } = require('./codejail')
    jail_code("node", "x+1", "p1", { f1: "f1", f2: "f2" }, "", "x1")
    .then -> run("mnode", "x+y+z")
    .then (-> console.log it), (-> console.log it)

main = ->
    build-mocks!
    run-tests!

main!






    
