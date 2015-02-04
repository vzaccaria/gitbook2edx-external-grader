#!/usr/bin/env sh 
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

bindir=$srcdir/..
npm=$srcdir/../node_modules/.bin


for f in $srcdir/*
do
	# is it a directory?
	if [ -d "$f" ]; then
		diff $f/output $f/reference
	fi
done
