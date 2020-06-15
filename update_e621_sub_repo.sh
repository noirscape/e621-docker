#!/bin/bash
# Note: requires git subrepo to be installed.
rm core/e621_code/REVISION
git subrepo pull core/e621_code
git rev-parse --short HEAD > core/e621_code/REVISION
git commit core/e621_code/REVISION -m "Add REVISION file"

