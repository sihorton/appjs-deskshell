#!/bin/bash
# This is the deskshell-helloworld app ported to Mac.

# Chromium's inside
ME="$(dirname $0)"
CHROMIUM_DIR="$ME/../../bin/mac/Chromium.app/Contents"

# First, add some environment for DYLD to work right
DYLD_LIBRARY_PATH=

# Starting Chromium...with windows' profile dir, cuz we can.
"$CHROMIUM_DIR/MacOS/Chromium" --remote-debugging-port=9222 --user-data-dir="$ME/../../bin/win/chrome-profile" --app="file://$ME/content/index.htm"
# run node application
"$ME/../../bin/mac/node" node-backend/app.js 