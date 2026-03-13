#!/bin/bash
# Fixes invalid CFBundleIdentifiers in gRPC frameworks bundled with Firebase.
# Add this as a Run Script build phase in Xcode (runs after build, before validation).

find "${BUILT_PRODUCTS_DIR}" -name "Info.plist" -path "*gRPC-C++*" 2>/dev/null | while read f; do
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.google.grpc-cpp" "$f" 2>/dev/null
done

find "${BUILT_PRODUCTS_DIR}" -name "Info.plist" -path "*gRPC-Core*" 2>/dev/null | while read f; do
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.google.grpc-core" "$f" 2>/dev/null
done
