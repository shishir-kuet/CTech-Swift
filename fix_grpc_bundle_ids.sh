#!/bin/bash
set -euo pipefail

# Fixes invalid CFBundleIdentifiers in gRPC frameworks bundled with Firebase.
# Add this as a Run Script build phase in Xcode (runs after build, before validation).

if [ -z "${BUILT_PRODUCTS_DIR:-}" ]; then
  echo "BUILT_PRODUCTS_DIR is not set; skipping gRPC bundle fix."
  exit 0
fi

find "${BUILT_PRODUCTS_DIR}" -name "Info.plist" -path "*gRPC-C++*" -print0 2>/dev/null | while IFS= read -r -d '' f; do
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.google.grpc-cpp" "$f" 2>/dev/null || true
done

find "${BUILT_PRODUCTS_DIR}" -name "Info.plist" -path "*gRPC-Core*" -print0 2>/dev/null | while IFS= read -r -d '' f; do
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.google.grpc-core" "$f" 2>/dev/null || true
done
