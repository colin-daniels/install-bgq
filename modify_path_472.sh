#!/bin/bash

# Load configuration data
. config

# Modify bgclang script and save original with .O extension as backup
set -x
sed -i.O "s@new_floor=/bgsys/drivers/toolchain/\${dvr}_base_4.7.2@new_floor=$GCC472_PATH@g" $PREFIX_BASE/$VERSION/bin/bgclang