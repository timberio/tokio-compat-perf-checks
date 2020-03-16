#!/bin/bash
timeout "${1:-"10"}" bash <<EOF
while true; do
  cat ./flog-100MiB.log \
    | socat -u - tcp:127.0.0.1:1521;
done
EOF
