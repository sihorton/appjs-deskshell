#!/bin/bash

# Create a dmg real quick.

# first, create a temporary folder
mkdir .tmp

# now copy everything in there
echo "=> Saving temporary files"
cp -R Deskshell.app README.md CHANGELOG.md ToDo.md ../../LICENSE .tmp/

# Get size of folder
KB=$(du -sk ./.tmp | awk '{print $1}')
MB=$(expr $KB / 1024 + 10)
echo "=> Total size of distribution in KB: $KB - size in MB: $MB"

# Create image
echo "=> Creating raw DMG..."
hdiutil create -megabytes $MB -fs HFS+ -volname "Deskshell" ./Deskshell

# Mount the image and copy everything inside
echo "=> Filling the image"
open -g ./Deskshell.dmg
cp -R .tmp/ /Volumes/Deskshell/
hdiutil detach /Volumes/Deskshell/

# Done.
 
echo "=> Erasing temporary files"
 rm -rf .tmp
