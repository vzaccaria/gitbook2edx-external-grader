#!/usr/bin/env lsc

{ parse, add-plugin } = require('newmake')

os = require('os')

cppCompiler = "clang++"
cppCompiler = "clang++-3.5" if os.platform() == "linux"

parse ->

    @add-plugin 'clangPre',(g, deps) ->
        @compile-files( (-> "#cppCompiler -c -I./src/cppformat -I./src -std=c++11 -DUSE_STD #{it.orig-complete} -o #{it.build-target}"), ".o", g, deps )

    @add-plugin 'link', (files) ->
        @reduce-files( ("#cppCompiler $^  -o $@"), "linked", "x", files)

    @collect "build", -> [

        @dest "./bin/octave-helper", ->
            @link -> [
                         @clang-pre 'src/*.cxx', 'src/*.hxx'
                         @clang-pre 'src/cppformat/format.cc'
                         ]
        ]

    @collect "all", ->
        @command-seq -> [
            @make "build"
            @cmd "./bin/octave-helper #{__dirname}/fix/t.m"
            ]

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./bin"
        ]
