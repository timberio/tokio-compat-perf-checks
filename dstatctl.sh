#!/bin/bash
set -euo pipefail

CMD="$1"

case "$CMD" in
  "start")
    FILE="$2"

    truncate -s0 "$FILE"
    dstat \
      --epoch \
      --cpu \
      --disk \
      --io \
      --load \
      --mem \
      --net \
      --proc \
      --proc-count \
      --sys \
      --socket \
      --tcp \
      --udp \
      --vm \
      --output "$FILE" \
      > /dev/null &
    ;;
  "stop")
    pkill -f dstat
    ;;
esac
