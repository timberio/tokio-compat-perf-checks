#!/bin/bash
set -euo pipefail

CMD="$1"

case "$CMD" in
  "start")
    FOR="$2"

    truncate -s0 "dstat-$FOR.csv"
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
      --output "dstat-$FOR.csv" \
      > /dev/null &
    ;;
  "stop")
    pkill -f dstat
    ;;
esac
