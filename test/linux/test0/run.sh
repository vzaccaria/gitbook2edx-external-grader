#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../../..
npm=$bindir/node_modules/.bin

($bindir/index.js run -e 'javascript' 'console.log("hi!")') > $srcdir/output
$npm/diff-files -m "Wet test of command line code execution should execute safe code (node+apparmor)" $srcdir/output $srcdir/reference

