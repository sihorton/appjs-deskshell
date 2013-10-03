# Changelog

## Deskshell for Mac

### 03th Oct. 2013
- Added stable and working PHP port.
	- PHP included with pthreads, sockets and curl extensions.
- Re-build Chromium to render certaint hings right, removing Update-button and other normal-browser things.
	- Note: The menu must have certain entries for things like CMD+C/CMD+V to work at all. That explains why it DIDNT work at original appJS v0.0.20!
- Including php_modules alongside node_modules
- included environment file to match the actual paths etc.
- Upgraded internal deskshell-api module to be the same as in Windows.
- Detected possibility to drasticaly upgrade performance. PHP port launches in at least half the time of nodejs. The fix is a while-loop mechanism.
- Changed the launcher-binary to a Platypus generated binary. Applescript adé.
- Upon being just double-clicked, the app now launches the demo app which is inside the bundle.
- Updated the installer/mac folder with a new script that will pull together and initialize the Deskshell.app bundle