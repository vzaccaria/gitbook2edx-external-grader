#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/../..
npm=$srcdir/../../node_modules/.bin

($bindir/index.js run -e 'mnode' 'console.log(require("fs").readdirSync("/"))') | sed -e '/tmp/d' > $srcdir/output
$npm/diff-files -m "Test safe jail: should not allow node accessing root directory" $srcdir/output $srcdir/reference

