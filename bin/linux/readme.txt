Linux
=====

This port is currently in the experimental stage and we don't yet have a distributable you can download.

For ubuntu it is easier to install packages with apt-get and then assume they are available on the path.

sudo apt-get install chromium-browser
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs

the required modules can then be globally installed or installed into each project, or the directory above projects.
npm install -g request

binaries:

We have not yet been able to get the binaries working.

chromium is listed for download here: http://sourceforge.net/projects/portable/files/
Download 32-bit nodejs binary from http://nodejs.org/download/
Extract node and npm to this directory.


As you can see this is very much a work in progress.
