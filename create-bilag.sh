#!/bin/bash

# Program to move or create a bilag file

function die() {
    echo "Error: " "$@"
    exit 1
}

FILE=$1
NUM=$2
CASE=$3

if test "x$NUM" == "x" ; then
    echo "Usage: $0 <file> <num> [<case>]"
    exit 2
fi

if ! test -a "$FILE" ; then
    die "'$FILE' does not appear to exist"
fi

# If case is given, file is assumed to be "new"
TARGET=""
if test "x$CASE" != "x" ; then
    echo "Moving file to target"
    TARGET="Bilag $NUM - $CASE - $FILE"
    mv "$FILE" "$TARGET" || die "Unable to do mv '$FILE' '$TARGET'"
else
    # No case given, assume it starts with "Bilag xx -"
    TARGET=`echo "$FILE" | perl -pe 's/.*Bilag \d+(\.\d+)? - //'`
    TARGET="Bilag $NUM - $TARGET"
    # If source is same directory as target, mv, otherwise copy
    TARGETDIR=`dirname "$TARGET"`
    SOURCEDIR=`dirname "$FILE"`
    if test "x$TARGETDIR" = "x$SOURCEDIR" ; then
        mv "$FILE" "$TARGET" || die "Unable to do mv '$FILE' '$TARGET'"
    else
        cp "$FILE" "$TARGET" || die "Unable to do cp '$FILE' '$TARGET'"
    fi
fi

# Now, create and output target
# echo "doing: mv '$FILE' '$TARGET'"

echo "$TARGET"

