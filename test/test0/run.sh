#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../..
npm=$srcdir/../../node_modules/.bin

node --harmony $bindir/lib/codejail-test.js > $srcdir/output
$npm/diff-files -m "Test safe jail launch through app-armor" $srcdir/output $srcdir/reference