#!/usr/bin/env bash
# Delete trash every week

if [ $(date +%u) -eq 7 ]; then
    rm -rf ~/.local/share/Trash/*
    echo "Deleted in $(date +'%Y-%m-%d')" >> ~/.local/share/date.txt
fi

exit
