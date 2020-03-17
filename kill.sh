#!/bin/bash
PROCLIST="$(ps -o pid=,comm=)"
echo "$PROCLIST" | grep -v -E "(ps|$$|$PPID)" | awk '{ print $1 }' | xargs kill
