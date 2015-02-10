#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../../..
npm=$bindir/node_modules/.bin

$bindir/index.js run 'var x=1' -d > $srcdir/output
$npm/diff-files -m "Test correct command sequence for using app-armor from command-line" $srcdir/output $srcdir/reference
