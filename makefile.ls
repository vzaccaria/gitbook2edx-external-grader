#!/usr/bin/env lsc

_ = require('lodash')
{ parse, add-plugin } = require('newmake')

os = require('os')
nodePath = "/usr/local/bin/node"
nodePath = "/usr/bin/node" if os.platform() == 'linux'

parse ->
    @add-plugin "ls", (g) ->
      @compile-files( (-> "./node_modules/.bin/lsc -p -c #{it.orig-complete} > #{it.build-target}" ) , ".js", g)

    @add-plugin "lsc", (g) ->
        cmd1 = -> "./node_modules/.bin/lsc -p -c #{it.orig-complete}"
        echo = -> "echo '#!#{nodePath} --harmony'"

        app = (f1, f2) ->
            -> "(#{f1(it)} && #{f2(it)})"

        final = _.reduce([cmd1], app, echo)

        f = -> "#{final(it)} > #{it.build-target}"

        @compile-files( f, ".js", g)

    @collect "all", ->
        @command-seq -> [

            @collect "compile", -> [
                @toDir "./lib", { strip: "src" }, ->
                    @ls ("./src/**/*.ls")

                @toDir "./lib", { strip: "src" }, ->
                        @glob ("./src/**/*.js")

                @toDir ".", ->
                    @lsc ("./index.ls")
            ]
            @make 'helpers'
            @cmd "chmod +x ./index.js"
        ]

    @collect "update", ->
      @cmd "./node_modules/.bin/lsc makefile.ls"

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./lib"
    ]

    @collect "helpers", -> [
        @cmd "cd helpers/gitbook2edx-octave-helper && ../../node_modules/.bin/lsc ./makefile.ls && make clean && DEBUG=edx:* make"
        ]

    @collect "test-server", -> [
        @command-seq -> [
                @make 'compile'
                @cmd "./node_modules/.bin/mocha -C --harmony ./lib/test/server-test.js -R spec"
                ]
        ]


    @collect "test", -> [
        @command-seq -> [
            @make 'clean'
            @make 'all'
            @cmd "./node_modules/.bin/mocha -C --harmony ./lib/test/armor-test.js -R spec"
            @cmd "./node_modules/.bin/mocha -C --harmony ./lib/test/server-test.js -R spec"
            ]
    ]

    @collect "linux-test", -> [
        @command-seq -> [
          @cmd "cd ./ansible/_vagrant && vagrant up"
          @cmd "ssh vagrant@192.168.33.10 'rm -rf /home/vagrant/gitbook2edx'"
          @cmd "rsync -rav -e ssh --exclude='node_modules' --exclude='.git' . vagrant@192.168.33.10:/home/vagrant/gitbook2edx"
          @cmd "ssh vagrant@192.168.33.10  'cd /home/vagrant/gitbook2edx && npm install && make update && make clean && make test'"
          ]
        ]

    @collect "quick-linux-test", -> [
            @command-seq -> [
              @cmd "rsync -rav -e ssh --exclude='node_modules' --exclude='.git' . vagrant@192.168.33.10:/home/vagrant/gitbook2edx"
              @cmd "ssh vagrant@192.168.33.10  'cd /home/vagrant/gitbook2edx && make update && make clean && make test'"
              ]
            ]

    for l in ["major", "minor", "patch"]

        @collect "release-#l", -> [
            @cmd "./node_modules/.bin/xyz --increment #l"
        ]


    @collect "start", -> [
        @command-seq -> [
            @make "all"
            @cmd  "./node_modules/.bin/pm2 start ./other/grader.json"
            @cmd  "./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader"
            @cmd  "./node_modules/.bin/pm2 logs grader"
            @cmd  "echo 'Connect to http://localhost:4040 to watch for incoming traffic"
            ]
        ]

    @collect "stop", -> [
        @cmd  "./node_modules/.bin/pm2 delete all"
        ]

    @collect "monit", -> [
        @cmd  "./node_modules/.bin/pm2 monit"
        ]

    @collect "s", -> [
        @cmd "./node_modules/.bin/pm2 status"
        ]
