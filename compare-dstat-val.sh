#!/bin/bash
set -euo pipefail
FIELD="$1"
FILE="$2"
tail -n +7 < "$FILE" | awk -F, "{sum+=\$$FIELD} END {print sum}"
