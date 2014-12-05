#!/bin/bash

# Script to update an agenda based on its version number.
# Also opens it in the program associated with .odt files.

# Helper function
function die() {
    echo "Error: " "$@"
    exit 1
}

# Get the include stuff. 
which realpath &> /dev/null || die "Unable to locate realpath binary"
which dirname &> /dev/null || die "Unable to locate dirname binary"
BASEDIR=$(dirname $(realpath "$0"))
. "$BASEDIR"/inc-agenda.sh
# PATH="$BASEDIR":$PATH

# This is our usage function - but no way to get to it... todo?
function usage() {
    echo "$0"
    exit 1;
}

# Locate newest dagsorden and create new name from it
CUR_AGENDA=$(_get-newest-agenda) || die "Could not find an agenda file"
NEW_AGENDA=$(_update-agenda-version "$CUR_AGENDA") || die "Could not update the version number"

# echo "NEW=$NEW_AGENDA"

# Make sure not to overwrite existing file
test -a "$NEW_AGENDA" && die "Target file $NEW_AGENDA already exists"

# Check if this is really what the user wants.
echo "Create new dagsorden $NEW_AGENDA from $CUR_AGENDA?"
if ! _proceed-assume-yes ; then
    exit 0;
fi

# Copy existing to new number, open it
cp "$CUR_AGENDA" "$NEW_AGENDA"
kde-open "$NEW_AGENDA"
