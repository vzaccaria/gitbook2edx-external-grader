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
$npm/diff-files -m "Dry test of command line interface should work" $srcdir/output $srcdir/reference
