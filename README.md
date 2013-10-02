appjs-deskshell
===============

SDK for building desktop applications using html5 / css / js. A simple json file with a .desk extension launches
a desktop app with a frontend built using web technologies. The application can communicate with a backend
built using familiar server scripts like nodejs or php. This backend allows you to access databases,
write to disk and do whatever you need outside of the browser sandbox.


Windows:
========

The quickest way to start using deskshell for windows is to download the installer. This includes an example app
that also serves as documentation and guide for the project. http://appjs.delightfulsoftware.com/deskshell/.
To develop the code git clone the repository and then read the bin/win/readme.txt file for further details.

Mac:
====
On mac git clone the repository, then cd to installer/mac and then run setup.nsr with nodejs. If you don't already 
have nodejs installed then install from http://nodejs.org/download/. Once installed run setup.nsr:

     node setup.nsr
     
The script will create a folder Deskshell.app and will pull in the source code from the bin/mac directory. It will
then download a binary that contains all of the Chromium and other required files. The download and extraction
can take some time so leave it running until it is complete. Leave the binary there and the next time you run
setup it will reuse the binary from last time.

Once the script is complete you will then have a Deskshell.app folder that you can run. The first run of the app
registers the .desk files and from then on you can click on a .desk file to run it.

Mac port instructions are here: https://github.com/sihorton/appjs-deskshell/tree/master/bin/mac

There is a pre-built binary also available for the mac: http://appjs.delightfulsoftware.com/deskshell/ 

Linux:
============

Take a look at bin/linux folder. We will release an installer in the future.



See http://appjs.delightfulsoftware.com/ for my previous work on packaging appjs for windows and linux.
