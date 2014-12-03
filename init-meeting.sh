#!/bin/bash

# Script to create the first meeting in a series, based on the template
TEMPLATEDIR=TemplateAndMacros
TEMPLATENAME=$TEMPLATEDIR/dagsorden-2014-12-31-v1.odt

# Get the include stuff. 
which realpath &> /dev/null || die "Unable to locate realpath binary"
which dirname &> /dev/null || die "Unable to locate dirname binary"
BASEDIR=$(dirname $(realpath "$0"))
. "$BASEDIR"/inc-agenda.sh
# PATH="$BASEDIR":$PATH
TEMPLATE="$BASEDIR/$TEMPLATENAME"

# Check arguments.
SETUPDIR="$1"
if test "x$SETUPDIR" = "x" ; then
    echo "Usage: $0 <setupdir>"
    exit 1
fi
HERE=`pwd`

# Helper function
function die() {
    echo "Error: " "$@"
    exit 1
}

test -a "$SETUPDIR" && die "$SETUPDIR must not exist"

# Match against one of two patterns, either YYYYMMDD, or MMDD (where YYYY is current year)
if [[ "$SETUPDIR" =~ ^([0-9]{2})([0-9]{2})$ ]] ; then
    TOYEAR=`date +"%Y"`
    TOMONTH=${BASH_REMATCH[1]}
    TODAY=${BASH_REMATCH[2]}
else 
    if [[ "$SETUPDIR" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})$ ]] ; then
        TOYEAR=${BASH_REMATCH[1]}
        TOMONTH=${BASH_REMATCH[2]}
        TODAY=${BASH_REMATCH[3]}
    else
        die "Unsupported date format : $SETUPDIR"
    fi
fi

# Find the template
test -a "$TEMPLATE" || die "Could not find $TEMPLATE" 

# Create the directory structure
mkdir "$SETUPDIR" || die "Unable to create directory $SETUPDIR"
mkdir "$SETUPDIR/Bilag" || die "Unable to create directory $SETUPDIR/Bilag"

# Create the new minutes that matches the meeting
TOAGENDAODT="$SETUPDIR"/$AGENDA_WORD-$TOYEAR-$TOMONTH-$TODAY-v1.odt
cp "$TEMPLATE" "$TOAGENDAODT" || die "Unable to create $TOAGENDAODT from $TEMPLATE"

# Feedback and open
tree "$SETUPDIR"
echo "Hit Return to edit $TOAGENDAODT - or Ctrl+C to abort"
read FOO
kde-open "$TOAGENDAODT"


