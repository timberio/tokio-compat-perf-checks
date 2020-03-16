#!/bin/bash
set -euo pipefail

PKG="$1"

cargo build -p "$PKG"

exec strace -c -o "trace-$PKG.txt" "target/debug/$PKG"
