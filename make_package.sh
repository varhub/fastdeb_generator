#!/bin/sh
#
# Copyright (c) 2015
# Author: Victor Arribas <v.arribas.urjc@gmail.com>
# License: GPLv3 <http://www.gnu.org/licenses/gpl-3.0.html>
#
# Usage:
# make_package.sh [package.info] [...]
# Creates debian packages for passed control files
# or every *.info at current directory.
# Arguments:
#    package.info - debian/control file


if [ -z "$1" ]
then
	packages=*.info
else
	packages=$@
fi


set -e
set -u

if ! test -n "$packages"
then
	echo "No packages to build."
	exit 1
fi


build=.build_dpkg
mkdir -p $build
for pkginfo in $packages
do
	pkgname=${pkginfo%.info}
	target=$build/$pkgname/DEBIAN
	mkdir -p $target
	cp $pkginfo $target/control
	dpkg --build $build/$pkgname && \
	mv $build/${pkgname}.deb .
done

rm -r $build
