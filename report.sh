#!/bin/bash
set -euo pipefail

NAME_COL_LEN=20

print_dstat_stat() {
  local HEADER="$1"
  local HEADER_NUM="$2"
  echo "dstat ${HEADER}:"
  for DSTAT_FILE in dstat-*.csv; do
    DSTAT_RECV="$(./compare-dstat-val.sh "$HEADER_NUM" "$DSTAT_FILE")"
    NAME="${DSTAT_FILE}"
    NAME="${NAME/dstat-/}"
    NAME="${NAME/.csv/}"
    printf "  %*s\t%s\n" "-$NAME_COL_LEN" "$NAME" "$DSTAT_RECV"
  done
}

print_dstat_stat "net recv" 18
print_dstat_stat "net tcp syn" 34

echo "tcp test server message_count:"
for TEST_SERVER_SUMMARY_FILE in tcp_test_server_summary-*.json; do
  MESSAGE_COUNT="$(jq '.message_count' < "$TEST_SERVER_SUMMARY_FILE")"
  NAME="${TEST_SERVER_SUMMARY_FILE}"
  NAME="${NAME/tcp_test_server_summary-/}"
  NAME="${NAME/.json/}"
  printf "  %*s\t%s\n" "-$NAME_COL_LEN" "$NAME" "$MESSAGE_COUNT"
done
