#!/bin/bash
set -euo pipefail

NAME="$1"; shift

exec strace -c -o "trace-$NAME.txt" "$@"
