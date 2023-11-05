#!/bin/bash
# Delete trash every week
if [ $(date +%u) -eq 7 ]; then
    echo "Deleting trash"
    rm -rf ~/.local/share/Trash/*
    echo echo "Deleted in $(date +'%Y-%m-%d')" >> ~/.local/share/date.txt
fi

exit
