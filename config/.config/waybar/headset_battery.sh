#!/usr/bin/env bash

BATTERY=$(headsetcontrol -b | grep "Level:" | awk '{print $2}')

if [ -z "$BATTERY" ]; then
    echo ""
else
    echo "🎧 $BATTERY"
fi
