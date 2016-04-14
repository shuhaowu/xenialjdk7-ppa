#!/bin/bash

if ! git diff-index --quiet HEAD --; then
  echo "ERROR: There are changes on the branch. Only run this script when there's no more changes." >&2
  exit 1
fi

TARBALL=openjdk-7_7u95-2.6.4.orig.tar.gz
URL="https://launchpad.net/ubuntu/+archive/primary/+files/openjdk-7_7u95-2.6.4.orig.tar.gz"
SHA=e60bfbd655fd317d3e723fb59d064ccd25c5264bc48da29f0365864595b7a8f0

set -xe
cd build

if [ ! -f $TARBALL ]; then
  wget $URL
  sha256sum $TARBALL | grep $SHA
  tar xvzf $TARBALL
fi

cp -r ../openjdk7/debian openjdk-7-7u95-2.6.4/debian

pushd openjdk-7-7u95-2.6.4
  debuild -S -sa
popd

dput ppa:shuhao/xenialjdk7 openjdk-7_7u95-2.6.4-0shuhao0.16.04.0_source.changes

