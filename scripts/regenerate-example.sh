#! /usr/bin/env bash

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
cd "${DIR}"

# Generate
./scripts/generate.sh client -i https://petstore.swagger.io/v2/swagger.json

# Replace example
rm -r example/client >/dev/null 2>&1 || true
cp -r generated/client example
