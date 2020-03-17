#!/bin/bash
set -euo pipefail

FILE="$1"; shift

exec strace -c -o "$FILE" "$@"
