#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in
  unit)
    xcodebuild -scheme DropBear-Package -destination 'name=iPhone 16 Pro,OS=18.6' clean test
    ;;
  ui)
    xcodebuild -project Examples/DropBear.xcodeproj -scheme DropBearApp -destination 'name=iPhone 16 Pro,OS=18.6' clean test
    ;;
  *)
    echo "Usage: $0 {unit|ui}" >&2
    exit 1
    ;;
esac