# Include files for the agenda system.

shopt -s nocasematch

# Helper function
function die () {
    echo "Error:" "$@"
    exit 1
}

# Never can figure this out
export TRUE=0
export FALSE=1

# Feedback from user
# returns true if OK to proceed, false otherwise.
# Enter without input => true
function _proceed-assume-yes() {
    #_log ">> _proceed-assume-yes"
    read -e -p "Proceed? [Y/n]: "
    REPLY="${REPLY:-Y}"
    if test "x$REPLY" = "xy" -o "x$REPLY" = "xY" ; then
        #_log "= true"
        return $TRUE
    else
        #_log "= false"
        return $FALSE
    fi
}

# Define words
AGENDA_WORD=dagsorden
MINUTES_WORD=referat
AGENDA_WORDE={d,D}agsorden
AGENDA_WORDR=[dD]agsorden
MINUTES_WORDE={r,R}eferat
MINUTES_WORDR=[rR]eferat

# Get the highest numbered agenda.
function _get-newest-agenda() {
    PATTERN=`eval echo $AGENDA_WORDE-*v*.odt`
    AGENDA=`ls $PATTERN 2>/dev/null | sort -t 'v' -g | tail -1`
    [[ "$AGENDA" =~ $AGENDA_WORDR-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-v[0-9].odt ]] || die "Name $AGENDA does not match $AGENDA_WORDR-YYYY-MM-DD-vN.odt"
    test -a "$AGENDA" || return $FALSE # die "Unable to access file $AGENDA"
    echo $AGENDA
    return $TRUE
}

# Get the highest numbered  minutes
function _get-newest-minutes() {
    PATTERN=`eval echo $MINUTES_WORDE-*v*.odt`
    MINUTES=`ls $PATTERN 2>/dev/null | sort -t 'v' -g | tail -1`
    [[ "$MINUTES" =~ $MINUTES_WORDR-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-v[0-9].odt ]] || die "Name $MINUTES does not match $MINUTES_WORDR-YYYY-MM-DD-vN.odt"
    test -a "$MINUTES" || return $FALSE # die "Unable to access file $AGENDA"
    echo $MINUTES
    return $TRUE
}

# Update an agenda name, that is, give it a newer version number
function _update-agenda-version() {
    AGENDA=$1
    # test -a "$AGENDA" || return $FALSE # die "Unable to access file $AGENDA"
    # Get the number - this sucks.
    NUM=`basename "$AGENDA" .odt | awk -Fv '{print $2}'`
    NUM=$(($NUM + 1))
    # Target name
    NEW_AGENDA=${AGENDA/-v[0-9]/-v$NUM}
    echo $NEW_AGENDA
}

# Transform agenda name to minutes name
# Changes the words, resets number to 1.
function _agenda-to-minutes() {
    AGENDA=$1
    # test -a "$AGENDA" || return $FALSE # die "Unable to access file $AGENDA"
    # Set the number to 1, changes words
    MINUTES=${AGENDA/-v[0-9]/-v1}
    MINUTES=${MINUTES/$AGENDA_WORD/$MINUTES_WORD}
    echo $MINUTES
}

