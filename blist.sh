#!/bin/bash

set -e

SNAPSHOTS_DIR="/.snapshots"

if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;33mCommand requires root privileges!\e[0m"
    exit 1
fi

SNAPSHOTS="$(btrfs subvolume list "$SNAPSHOTS_DIR" -s | cut -d " " -f14)"

echo "Snapshots:"
snapshot_count="0"

for snapshot in ${SNAPSHOTS[@]}; do
    snapshot_count=$((snapshot_count+1))
    echo "$snapshot_count) $snapshot"
done

echo -e "Count: $snapshot_count"

exit 0