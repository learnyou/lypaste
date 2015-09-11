#!/bin/sh

# Regenerates etags file automagically
#
# Requires hasktags and inotify

files () {
    git ls-tree -r HEAD --name-only | grep -E '*.hs'
}

while true; do
    inotifywait -e modify `files`
    hasktags -e --ignore-close-implementation `files`
done
