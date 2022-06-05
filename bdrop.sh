#!/bin/bash

SNAPSHOTS_DIR="/.snapshots"

if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;33mCommand requires root privileges!\e[0m"
    exit 1
fi

select-snapshot() {
    printf "Select snapshot to delete: "
    read -r selection
}

list-snapshots() {
    snapshots=("$SNAPSHOTS_DIR/"*)

    echo "Found snapshots in $SNAPSHOTS_DIR:"
    counter=0

    for snapshot in "${snapshots[@]}"; do
        echo "$counter) $snapshot"
        ((counter++))
    done
    echo -e "e) exit\n"
}

prevent-deleting-snapshot-dir() {
    case "$selection" in
        "$SNAPSHOTS_DIR"|"$SNAPSHOTS_DIR/"|"$SNAPSHOTS_DIR/*"|"$SNAPSHOTS_DIR*")
            echo "\e[1;31mError: Deleting the snapshot directory is not allowed.\e[0m"
            exit 1
            ;;
        *) ;;
    esac    
}

delete-snapshot() {
    snapshot_to_delete="${snapshots[$selection]}"
    printf "Do you really want to remove snapshot '%s'? [Y/n]: " "$snapshot_to_delete"
    read -r confirmation
    case "$confirmation" in
        "y"|"Y"|"yes"|"Yes"|"")
            echo "Removing snapshot: $snapshot_to_delete"
            prevent-deleting-snapshot-dir
            btrfs subvolume delete "$snapshot_to_delete"
            echo -e "\e[1;32mRemoved snapshot.\e[0m"
            ;;
        *)
            echo -e "\e[1;33mAbort removal.\e[0m";
            ;;
    esac
}

delete-oldest-snapshot() {
    snapshots=("$SNAPSHOTS_DIR/"*)
    delete-snapshot
}

interative-delete() {
    while [[ "$selection" != 'e' ]]; do
        list-snapshots
        select-snapshot

        if [[ "$selection" == 'e' || "$selection" == 'q'  || "$selection" == 'exit' || "$selection" == 'quit' ]]; then
            exit 0
        fi
        
        if [[ "" != "$selection" && "$selection" -ge "0" && "$selection" -lt "$counter" ]]; then
            delete-snapshot "$selection"
        else
            echo -e "\e[1;33mInvalid input. Select again.\e[0m"
        fi

        echo ""
    done
}

case "$1" in
    "--oldest"|"--old"|"-o")
        delete-oldest-snapshot;
        ;;
    *)
        interative-delete;
        ;;
esac

exit 0
