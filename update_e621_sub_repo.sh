#!/bin/bash
# Note: requires git subrepo to be installed.
git rm core/e621_code/REVISION
git commit -m "Delete REVISION file"
git subrepo pull core/e621_code
git rev-parse --short HEAD > core/e621_code/REVISION
git add core/e621_code/REVISION
git commit -m "Add REVISION file"

