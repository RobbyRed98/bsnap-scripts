# bsnap-scripts
A collection of btrfs snapshot helper scripts.

## List of scripts

This repository currently contains the following helper scripts:
* `bsnap.sh`<br>
  Creates a snapshot of the current the root mounted subvolume and saves it into the snapshots directory (`/.snapshots`).
  The snapshot is named after the datetime it was taken (`YYYY-MM-DD_hh:mm`).  A snapshot taken at the 1. January 2022 at 12:00 would 
  result in the following snapshot name `2022-01-01_12:00`.
* `bdrop.sh`<br>
  Helps to remove a existing snapshot found in the snapshots directory (`/.snapshots`). By default the script lists the existing snapshots 
  found in the snapshot directory and asks which directory to remove. When using the flag `--oldest` or it shorthands `--old` and `-o` 
  the script auto-selects the oldest snapshot for removal without listing all snapshots. The script will always ask for an confirmation 
  before removing a snapshot, no matter if the `--oldest` flag or its shorthands have been passed or not.