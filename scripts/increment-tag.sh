#!/usr/bin/env bash

opt=$1

git describe | cut -d- -f1  |
    { IFS="." read major minor patch

    case $opt in
    major) major=$(( major + 1 ));minor=1;patch=1;;
    minor) minor=$(( minor + 1 ));patch=1;;
    patch) patch=$(( patch + 1 ));;
    *) echo "Usage: $0 'major|minor|patch'"; exit 1;;
    esac

    ver="$major.$minor.$patch"

    # first check that there are no pending commits.
    git status | grep nothing
    git tag -a -m $ver $ver
    echo "Successfully created a tag $ver"
    exit 0
}
