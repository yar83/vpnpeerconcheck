#!/bin/bash
set -o nounset
set -o errexit

main() {
  echo "$1"
  echo "$2"
}

main "$@"
