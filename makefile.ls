#!/usr/bin/env lsc 

_ = require('lodash')
{ parse, add-plugin } = require('newmake')

parse ->

    @add-plugin "lsc", (g) ->
        cmd1 = -> "lsc -p -c #{it.orig-complete}"
        echo = -> "echo '#!/usr/local/bin/node --harmony'"

        app = (f1, f2) ->
            -> "(#{f1(it)} && #{f2(it)})"

        final = _.reduce([cmd1], app, echo)

        f = -> "#{final(it)} > #{it.build-target}"

        @compile-files( f, ".js", g)

    @collect "all", -> 
        @command-seq -> [

            @collect "compile", -> [
                @toDir "./lib", { strip: "src" }, -> 
                    @livescript ("./src/**/*.ls")

                @toDir "./lib", { strip: "src/test" }, -> 
                    @livescript ("./src/test/**/*.ls")

                @toDir ".", -> 
                    @lsc ("./index.ls")
            ]

            @cmd "chmod +x ./index.js"
            @make 'test'
        ]

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./lib"
    ]

    @collect "test", -> [
        @cmd "./test/test.sh"
        @cmd "./node_modules/.bin/mocha -C --harmony ./lib/server-test.js"
    ]


    for l in ["major", "minor", "patch"]

        @collect "release-#l", -> [
            @cmd "./node_modules/.bin/xyz --increment #l"
        ]


    @collect "start", -> [
        @command-seq -> [
            @make "all"
            @cmd  "./node_modules/.bin/pm2 start ./grader.json"
            @cmd  "./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader"
            @cmd  "./node_modules/.bin/pm2 logs grader"
            @cmd  "echo 'Connect to http://localhost:4040 to watch for incoming traffic"
            ]
        ]

    @collect "stop", -> [
        @cmd  "./node_modules/.bin/pm2 delete all"
        ]

    @collect "s", -> [
        @cmd "./node_modules/.bin/pm2 status"
        ]

