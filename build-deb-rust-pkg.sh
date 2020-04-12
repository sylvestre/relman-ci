#!/bin/bash

set -e -v

rm -f *
apt-get source --download-only $1/unstable
PKG=$(ls -1 *dsc)
sbuild --verbose --no-source --arch-any --arch-all -c debcargo-unstable-amd64-sbuild -d unstable --run-autopkgtest --autopkgtest-root-arg= --autopkgtest-opts="-- schroot debcargo-unstable-amd64-sbuild" $PKG
if grep -q "Autopkgtest: fail" *Z.build; then
	echo "Autopkgtest failed"
	exit 1
fi

