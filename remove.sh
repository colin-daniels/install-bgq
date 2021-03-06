#!/bin/bash

# Get version
if [ $# -lt 1 ]; then
  echo "error: missing argument: bgclang version" >&2
  exit 2
fi
VERSION=$1
if echo $VERSION | grep -qv "^r[0-9][0-9]*-[0-9][0-9]*$"; then
  echo "error: bad version '$VERSION': must be formatted as 'r[0-9]+-[0-9]+'" >&2
  exit 2
fi
echo "bgclang version: $VERSION"

# Get location of script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Load configuration data
. $DIR/config

# Remove bgclang directories
echo "Removing RPM directory $RPMDIR..."
rm -rf $RPMDIR
echo "Removing RPM database directory $RPMDBPATH..."
rm -rf $RPMDBPATH
echo "Removing install directory $PREFIX_BASE/$VERSION..."
rm -rf $PREFIX_BASE/$VERSION

echo "Done."
