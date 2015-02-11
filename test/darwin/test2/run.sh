#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../../..
npm=$bindir/node_modules/.bin

$bindir/index.js run 'console.log("ciao")' > $srcdir/output
$npm/diff-files -m "Wet test of command line code execution should work (node)" $srcdir/output $srcdir/reference
