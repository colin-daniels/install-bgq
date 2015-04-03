#!/bin/bash -e

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

# Copy RPM files to remote
echo "Copying RPM files to remote machine using rsync and '$SSH_COMMAND'..."
rsync -az --progress -e "$SSH_COMMAND" $RPMDIR/ :$REMOTE_RPMDIR
echo

# Execute the install on the remote machine
echo "Executing install on remote machine via '$SSH_COMMAND'..."
$SSH_COMMAND                 \
    VERSION=$VERSION         \
    RPMDIR=$REMOTE_RPMDIR    \
    PREFIX_BASE=$PREFIX_BASE \
    RPMDBPATH=$RPMDBPATH     \
    REMOTE_TEMP=$REMOTE_TEMP \
  'bash -se' <<'ENDSSH'

  # Create new RPM database directory
  echo "Creating new RPM database directory $RPMDBPATH..."
  mkdir -p $RPMDBPATH

  # Installing RPMs
  echo "Installing virtual packages..."
  rpm -Uhv --dbpath $RPMDBPATH --prefix $PREFIX_BASE/$VERSION \
      $RPMDIR/vpkg-bin-sh-*.ppc64.rpm
  echo

  echo "Installing stage 1 packages..."
  rpm -Uhv --dbpath $RPMDBPATH --prefix $PREFIX_BASE/$VERSION \
      $RPMDIR/bgclang-stage1-*.ppc64.rpm
  echo

  echo "Installing stage 2 packages..."
  rpm -Uhv --dbpath $RPMDBPATH --prefix $PREFIX_BASE/$VERSION \
      $RPMDIR/bgclang-stage2-*.ppc64.rpm
  echo

  echo "Installing bgclang packages..."
  rpm -Uhv --dbpath $RPMDBPATH --prefix $PREFIX_BASE/$VERSION \
          $RPMDIR/bgclang-binutils-r*.ppc64.rpm \
          $RPMDIR/bgclang-gdb-r*.ppc64.rpm \
          $RPMDIR/bgclang-r*.ppc64.rpm \
          $RPMDIR/bgclang-compiler-rt-r*.ppc64.rpm \
          $RPMDIR/bgclang-libcxx-r*.rpm \
          $RPMDIR/bgclang-libomp-r*.ppc64.rpm \
          $RPMDIR/bgclang-sleef-r*.ppc64.rpm
  echo

  if [ $REMOTE_TEMP -eq 1 ]; then
    echo "Removing temporary RPM files..."
    rm -rf $RPMDIR
    echo
  fi
ENDSSH

# Install modulefile
if [ $INSTALL_MODULEFILE -eq 1 ]; then
  echo "Copying modulefile to $MODULEFILE_DIR/$VERSION on remote machine..."

  # Replace version and path in modulefile template and output to a temporary file
  TMPFILE=$(mktemp)

  sed "s@VERSION@$VERSION@" $DIR/modulefile-template \
    | sed "s@PREFIX@$PREFIX_BASE/$VERSION@" >> $TMPFILE

  # Copy edited file to remote
  rsync -az --progress -e "$SSH_COMMAND" $TMPFILE :$MODULEFILE_DIR/$VERSION

  rm $TMPFILE
  echo
fi

echo "Done."
