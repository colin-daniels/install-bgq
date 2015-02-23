#!/bin/bash

# Load configuration data
. config

# Install
set -x
rpm -Uhv --dbpath $RPMDBPATH --prefix $PREFIX_BASE/$VERSION $RPMDIR/vpkg-bin-sh-*.ppc64.rpm