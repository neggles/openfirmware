#!/usr/bin/env bash

# Script to invoke the FirmWorks build facility.
# Usage:  build [-c|d|h|q|t|v] [target-name]
#
# This script automates the process of setting the BP and HOSTDIR
# environment variables and parses the option flags [-c|d|h|q|t|v].

# In order to run the build facility without this script:
# Set the BP environment variable to the firmware root directory
# Set the HOSTDIR environment variable to ${BP}/cpu/<cpuname>/<osname>,
#   e.g. ${BP}/cpu/arm/Linux
# Execute:
#    ${HOSTDIR}/forth ${HOSTDIR}/../native.dic
# At the "ok" prompt, type:
#    build <target-name>
# or
#    tag <target-name>

# Set BP by asking git, or searching upward for the root dir
if [[ -n $BP ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) = "true" ]]; then
        BP=$(git rev-parse --show-toplevel)
    else
        cdir="$(pwd)"
        {
            until [ -d ofw ]; do
                if [[ $PWD = '/' ]]; then
                    echo "Can't find firmware root directory!"
                    exit 1
                fi
                cd ..
            done
            BP=$(pwd)
        }
        cd "$cdir" || exit 1
    fi
    export BP
fi

# Set HOSTDIR according to the value of BP and the host system
if [[ -n $HOSTDIR ]]; then
    OSNAME=$(uname)
    CPUNAME=$(${SHELL} "${BP}/forth/lib/hostcpu.sh")
    export HOSTDIR="${BP}/cpu/${CPUNAME}/${OSNAME}"
fi

command=build

# Parse option flags
case $1 in
    -c) mode=clean;	shift ;;
    -d) mode=prolix;	shift ;;
    -q) mode=quiet;	shift ;;
    -t) command=tag;	shift ;;
    -v) mode=verbose;	shift ;;
    -h)
  echo "Usage:  build [-c|d|h|q|t|v] [target-name]"
  echo "    With no flags, shows commands that are executed to rebuild targets"
  echo "    -c: clean - ignores log files"
  echo "    -d: debug - shows the names of source files as they are checked"
  echo "    -h: display this helpful message"
  echo "    -q: quiet - suppresses normal showing of targets being rebuilt"
  echo "    -t: tag - used after a successful build, sends to stdout a list"
  echo "        of all the source files that were used in that build"
  echo "    -v: verbose - shows progress of dependency checking"
  echo ""
  echo "    Target-name may, but need not, have an extension"
  echo ""
  echo "    If target-name is omitted, the builder is executed interactively"
        exit 0;;
    *)  unset mode ;;
esac

FORTH=${FORTH:-"${HOSTDIR}/forth"}
NATIVE=${NATIVE:-"${HOSTDIR}/../build/builder.dic"}

if [[ $(basename "$0") = "forth" ]]; then
    mode=".copyright interact"
    if [ $# -eq 0 ]; then
	    exec "${FORTH}" "${NATIVE}" -s "$mode $command $*"
    elif [[ $(basename "$1") != $(basename "$1" .dic).dic ]]; then
	    exec "${FORTH}" "${NATIVE}" "$@"
    else
	    exec "${FORTH}" "$@"
    fi
elif [ $# -eq 0 ]; then		# Ensure the "target-name" argument is present
    echo "No target name specified; executing builder in interactive mode"
    mode=interact
fi

"${FORTH}" "${NATIVE}" -s "$mode $command $*"
