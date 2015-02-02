#!/usr/bin/env lsc 

_ = require('lodash')
{ parse, add-plugin } = require('newmake')

parse ->
    @add-plugin "lsc", (g) ->
        cmd1 = -> "lsc -p -c #{it.orig-complete}"
        echo = -> "echo '#!/usr/bin/env node --harmony'"

        app = (f1, f2) ->
            -> "(#{f1(it)} && #{f2(it)})"

        final = _.reduce([cmd1], app, echo)

        f = -> "#{final(it)} > #{it.build-target}"

        @compile-files( f, ".js", g)

    @collect "all", -> 
        @command-seq -> [
            @toDir "./lib", { strip: ("src") },  -> 
                        @livescript ("./src/**/*.ls")
            @toDir ".", -> 
                @lsc ("./index.ls")
            @cmd "chmod +x ./index.js"
        ]

    @collect "clean", -> [
        @remove-all-targets()
    ]

    @collect "watch", -> 
        @command-seq -> [
            @make 'all'
            @cmd "DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'"
            ]

