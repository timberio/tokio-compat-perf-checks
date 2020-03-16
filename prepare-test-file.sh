#!/bin/bash
set -euo pipefail

# Install with `go get -u github.com/mingrammer/flog`

flog --format apache_common --bytes 104857600 \
  | jq -c --raw-input '{msg: .}' \
  > ./flog-100MiB.log
