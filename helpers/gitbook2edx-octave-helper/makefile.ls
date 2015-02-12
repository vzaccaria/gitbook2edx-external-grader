#!/usr/bin/env lsc 

{ parse, add-plugin } = require('newmake')

cppCompiler = "clang++"

parse ->

    @add-plugin 'clangPre',(g, deps) ->
        @compile-files( (-> "#cppCompiler -c -I./src -std=c++11 -DUSE_STD #{it.orig-complete} -o #{it.build-target}"), ".o", g, deps )

    @add-plugin 'link', (files) ->
        @reduce-files( ("#cppCompiler $^  -o $@"), "linked", "x", files)

    @collect "build", -> [

        @dest "./bin/octave-helper", ->
            @link -> [
                         @clang-pre 'src/*.cxx', 'src/*.hxx'
                         ]
        ]
        
    @collect "all", ->
        @command-seq -> [
            @make "build"
            @cmd "./bin/octave-helper ./fix/t.m"
            ]

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./bin"
        ]


