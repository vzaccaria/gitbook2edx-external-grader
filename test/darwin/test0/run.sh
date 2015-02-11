#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../../..
npm=$bindir/node_modules/.bin

node --harmony $bindir/lib/codejail-test.js > $srcdir/output
$npm/diff-files -m "Unit test of codejail with fake data should work" $srcdir/output $srcdir/reference
