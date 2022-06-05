#!/bin/bash

set -e

SNAPSHOTS_DIR="/.snapshots"

if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;33mCommand requires root privileges!\e[0m"
    exit 1
fi

TIMESTAMP="$(date '+%Y-%m-%d_%H:%M')"

btrfs subvolume snapshot / "$SNAPSHOTS_DIR/$TIMESTAMP"

exit 0
