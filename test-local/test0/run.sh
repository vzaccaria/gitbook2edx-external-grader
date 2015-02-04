#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../..
npm=$srcdir/../../node_modules/.bin

($bindir/index.js run -e 'mnode' 'console.log("hi!")') > $srcdir/output
$npm/diff-files -m "Test safe jail: should allow node printing a message" $srcdir/output $srcdir/reference

