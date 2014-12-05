#!/bin/bash

# Script to create a referat from the newest dagsorden
# Also opens it in the file associated with .odt files.

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

# Check parameters - not really used
function usage() {
    echo "$0"
    exit 1;
}

# Get the newest agenda, create minutes from it
CUR_AGENDA=$(_get-newest-agenda) || die "Could not find an agenda file"
MINUTES=$(_agenda-to-minutes "$CUR_AGENDA") || die "Could not create minutes name from agenda name"

# Check that minutes does not already exist
test -a "$MINUTES" && die "Target file $MINUTES already exists"

# Check if this is really what the user wants.
echo "Create new minutes $MINUTES from $CUR_AGENDA?"
if ! _proceed-assume-yes ; then
    exit 0;
fi

# Actually do it.
cp "$CUR_AGENDA" "$MINUTES"
kde-open "$MINUTES"


