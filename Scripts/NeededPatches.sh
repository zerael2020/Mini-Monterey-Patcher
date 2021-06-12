#!/bin/bash

#
#  NeededPatches.sh
#  Mini Monterey
#
#  Created by Ben Sova on 5/15/21
#

exitIfUnknown() {
    if [[ "$1" == "--rerun" ]]; then
        echo "Failed to find Needed Patches, this Mac probably doesn't support the patcher (or just doesn't need it)." 1>&2
        exit 1
    fi
}

if [ -z "$PATCHMODE" ]
then
    MODEL=`sysctl -n hw.model`
    case $MODEL in
        ;;
    Macmini6,?|MacBookAir5,?|MacBookPro9,?|MacBookPro10,?|iMac13,?|MacPro[45],1)
        echo "(2012):BOOTPLIST:HD4000"
        BOOTPLIST="--bootPlist" HD4000="--hd4000"
        ;;
    iMac14,[123])
        echo "(2013+):BOOTPLIST"
        BOOTPLIST="--bootPlist" NOREBUILD="--noRebuild"
        ;;
    # Everything else
    *)
        echo "UNKNOWN"
        exitIfUnknown
        ;;
    esac
fi

if [ -z "`ioreg -l | fgrep 802.11 | fgrep ac`" ]; then
    echo "(MORE):WIFI"
    WIFI="--wifi"
fi

if [[ "$1" == "--rerun" ]]; then
    echo "Running PatchSystem.sh..."
    "$(dirname "$0")/../PatchSystem.sh" $WIFI  $HD4000 $BOOTPLIST $NOREBUILD $2
    exit $?
fi