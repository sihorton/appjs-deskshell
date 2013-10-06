#!/bin/bash
# Heh...havent written one of these in ages - and im not talking about single wrappers.
echo "=> Self-setup"
ME=$(dirname "$0")
URL="http://drag0ninstaller.tk/deskshell-bin.tgz"
cd $ME
if [ ! -f "deskshell-bin.tgz" ]; then
	echo "=> Downloading: $URL"
	curl -O -# $URL
else
	echo "=> Skipping download, it exists."
fi
echo "=> Extracting. Checking for binary container first."
tar -xvf deskshell-bin.tgz 2>&1 | while read l; do echo -n "."; done
echo
if [ -d "./deskshell_binary_dist" ]; then
	echo "=> Binary container exists, proceeding."
else
	echo "=> Error! The binary container was not detected.";
	exit 1
fi 
echo "=> Creating bundle... Be patient."
mkdir -p Deskshell.app/Contents
cp -Rv ../../bin/mac/deskshell_bundle/* ./Deskshell.app/Contents | while read l; do echo -n "."; done
cp -Rv deskshell_binary_dist/* ./Deskshell.app/Contents | while read l; do echo -n "."; done
echo
if [ ! -d "../../bin/mac/Deskshell.app" ]; then
	echo "=> Placing the result into the bin/mac folder"
	mv -v Deskshell.app ../../bin/mac
else
	echo "=> There is an existing Deskshell.app in bin/mac. Rename it or copy the result yourself."
fi