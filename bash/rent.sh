#!/bin/bash
#
# rent.sh 
#
# Manage rent due date and payments
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name
declare -rxi SEC_IN_DAY=86400
declare -rxi DEBUG=0 # 1=on 0=off

# Settings
declare -r DB="/home/tobin/.rent/rent.db" # file used to store rent database
declare -ri RENT=390

# Functions
# -------------------

# print out rent due message
function rent_due {
    declare DUE_STR # date rent is due complete string form
    declare -i DUE_SEC # date due in seconds since epoc form
    declare -i DATE_SEC # date now in seconds since epoc form
    declare -i SEC_TILL_DUE # seconds untill rent is due
    declare -i DAYS # days untill rent is due
    declare ALERT # alert string

    # Calculate values needed for alert string
    DUE_STR=$(tail -1 "$DB" | awk -F, '{print $3}') # get due date from db
    DUE_SEC=`date +"%s" -d "$DUE_STR"` # get seconds till due
    DATE_SEC=`date +"%s"` # get date now 
    SEC_TILL_DUE=$((DUE_SEC - DATE_SEC)) # calculate seconds untill due
    DAYS=$((SEC_TILL_DUE / SEC_IN_DAY)) # convert to days
    
    # make alert string
    if [ "$DAYS" -lt 1 ]; then
        ALERT="OVERDUE PAY NOW: "
    elif [ "$DAYS" -lt 7 ]; then
        ALERT="Due this Friday: "
    else 
        ALERT="Due next Friday: "
    fi
    
    # output rent due message
    printf "%s " $ALERT
    date -d "$DUE_STR" +"%a %d %B"

    return 0
}

# Sanity Checks
# -------------------
#

if test -z "$BASH" ; then
    printf "$SCRIPT:$LINENO: please run this script with the bash shell" >&2
    exit 192
fi

if [ ! -f $DB ]; then
    printf "$SCRIPT: database file $DB does not appear to exist - aborting\n" >&2
    exit 192
fi

# Main Script 
# -------------------

if [ $# -eq 0 ]; then # print rent due date
    rent_due
    exit 0
fi

if [ $# -eq 1 ]; then
    printf "Usage: rent [-p amount]\n" >&2
    exit 192
fi

if [ $# -eq 2 ]; then
    # check option
    if [ "$1" != "-p" ]; then
        printf "Usage: rent [-p amount]\n" >&2
        exit 192
    fi
    
    # check amount argument
    amount=$2 
    re='^[0-9]+$' # integer regular expression
    if ! [[ $amount =~ $re ]] ; then
        echo "$SCRIPT: Argument 3 does not appear to be an integer" >&2;
        exit 192
    fi

    # check rent payment amount 
    let "remainder =  $amount % $RENT "
    if [ "$remainder" -ne 0 ]; then
        echo "$SCRIPT: Rent amount not whole week: $amount" >&2
        exit 192
    fi

    # test database file
    if [ ! -w $DB ]; then
        printf "$SCRIPT: database file $DB is not writable - aborting\n" >&2
        exit 192
    fi
      
    let "weeks = $amount / $RENT" # weeks rent paid
    let "days = $weeks * 7"
    
    now=`date`
    old_due=$(tail -1 "$DB" | awk -F, '{print $3}') # get due date from db
    new_due=`date -d "$old_due + $days days"`
    echo "$amount,$now,$new_due" >> $DB

    # print message
    printf "Payment added. "
    rent_due
    
fi

exit 0


