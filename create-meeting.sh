#!/bin/bash

# Script to create a meeting based on an earlier one.

# Get the include stuff. 
which realpath &> /dev/null || die "Unable to locate realpath binary"
which dirname &> /dev/null || die "Unable to locate dirname binary"
BASEDIR=$(dirname $(realpath "$0"))
. "$BASEDIR"/inc-agenda.sh
# PATH="$BASEDIR":$PATH

# Check arguments.
COPYPDF="yes"
if test "$1" = "--nopdf" ; then
    COPYPDF="no"
    shift
fi

CLONEFROM="$1"
CLONETO="$2"
if test "x$CLONETO" = "x" ; then
    echo "Usage: $0 [--nopdf] <clonefrom> <cloneto>"
    exit 1
fi
HERE=`pwd`

# Helper function
function die() {
    echo "Error: " "$@"
    exit 1
}

test -d "$CLONEFROM" || die "$CLONEFROM must be a directory"
test -a "$CLONETO" && die "$CLONETO must not exist"

# Match against one of two patterns, either YYYYMMDD, or MMDD (where YYYY is current year)
# For both from and too
if [[ "$CLONEFROM" =~ ^([0-9]{2})([0-9]{2})$ ]] ; then
    FROMYEAR=`date +"%Y"`
    FROMMONTH=${BASH_REMATCH[1]}
    FROMDAY=${BASH_REMATCH[2]}
else 
    if [[ "$CLONEFROM" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})$ ]] ; then
        FROMYEAR=${BASH_REMATCH[1]}
        FROMMONTH=${BASH_REMATCH[2]}
        FROMDAY=${BASH_REMATCH[3]}
    else
        die "Unsupported date format : $CLONEFROM"
    fi
fi

if [[ "$CLONETO" =~ ^([0-9]{2})([0-9]{2})$ ]] ; then
    TOYEAR=`date +"%Y"`
    TOMONTH=${BASH_REMATCH[1]}
    TODAY=${BASH_REMATCH[2]}
else 
    if [[ "$CLONETO" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})$ ]] ; then
        TOYEAR=${BASH_REMATCH[1]}
        TOMONTH=${BASH_REMATCH[2]}
        TODAY=${BASH_REMATCH[3]}
    else
        die "Unsupported date format : $CLONETO"
    fi
fi

# Find the relevant files in from directory
# Need to find a referat in both .odt and .pdf formats.
# Find the oldest version in .odt first

cd $CLONEFROM && MINUTES_ODT=$(_get-newest-minutes) || die "Unable to find newest minutes in $CLONEFROM"
# Find if PDF version is also there
MINUTES_PDF="${MINUTES_ODT%.*}".pdf
if test $COPYPDF = "yes" ; then 
    test -a "$MINUTES_PDF" || die "Unable to locate PDF version of $MINUTES_ODT in $CLONEFROM"
fi
cd "$HERE" || die "Unable to change dir to $HERE"
MINUTES_ODT_DIR="$CLONEFROM/$MINUTES_ODT"
MINUTES_PDF_DIR="$CLONEFROM/$MINUTES_PDF"
if test $COPYPDF = "yes" ; then 
    echo "Using $MINUTES_ODT_DIR and $MINUTES_PDF_DIR as sources"
else
echo "Using $MINUTES_ODT_DIR as source"
fi
# Configure a target agenda
TOAGENDAODT="$CLONETO"/$AGENDA_WORD-$TOYEAR-$TOMONTH-$TODAY-v1.odt
echo "Using $TOAGENDAODT as destination"

# Now, actually do something
mkdir "$CLONETO" || die "Unable to create directory $CLONETO"
    
cp "$MINUTES_ODT_DIR" "$TOAGENDAODT" || die "Unable to copy $FROMREFODT to $TOAGENDAODT" 

if test $COPYPDF = "yes"; then
    mkdir "$CLONETO/Bilag" || die "Unable to create directory $CLONETO/Bilag"
    cp "$MINUTES_PDF_DIR" "$CLONETO/Bilag" || die "Unable to copy $FROMREFPDF to $CLONETO/Bilag"
    cd "$CLONETO/Bilag" || die "Unable to cd to $CLONETO/Bilag"
    create-bilag.sh "$MINUTES_PDF" 1 || die "Unable to create bilag from $MINUTES_PDF in $CLONETO/Bilag"
    cd - || die "Unable to cd -"
fi

tree "$CLONETO"

echo "Hit Return to edit $TOAGENDAODT - or Ctrl+C to abort"
read FOO
kde-open "$TOAGENDAODT"

