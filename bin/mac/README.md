# The Mac port

Read the main readme for instructions on setting up the checked out source code to run apps.

## Initialize the app bundle
In a terminal:

	$ cd installer/mac
	$ ./bootstrap.sh

And you will have everything you need.

## How to run from command line
Do it like so:

	$ Deskshell.app/Contents/MacOS/wrapper [_.desk file_]
	
And it will run your .desk file, or open the demo app :)

### PHP backend?
Yes, we have a TRUE PHP backend - no nodejs trickery or anything - its a real PHP backend. To see an example, look app/php-demo1

## Mini Bundle
This little bundle will search for an installed Deskshell bundle - or more the one you just extracted - and will run its integrated .desk-file against it. As a funny side effect, the Deskshell icon isnt even shown, but rather the one from where the .desk file has opened! So, there is no trail left of the actual Deskshell name and you can use oyur brand, name and information. Customize the Info.plist file.

## Packaging Deskshell with a .desk file
I'll describe it in the terminal for now:

	$ cp Deskshell.app MyFatApp.app
	$ mkdir MyFatApp.app/Contents/Applications
	$ mv Path/to/my/app-folder/* MyFatApp.app/Contents/Applications
	$ rm MyFatApp.app/Contents/MacOS/deskshell
	$ rm -Rv MyFatApp.app/Contents/Resources/Scripts
	$ nano MyFatApp.app/Contents/MacOS/deskshell
		
		#!/bin/bash
		ME=$(dirname '$0')
		"$ME/desk_parse" "$ME/../Application/app.desk"
		
And thats it.

What we did was to erase our applescript launcher and replace it with a shell script to directly launch desk_parse with the .desk file, which is now inside the bundle, as well as everything else, like node_modules and such. :)

A more productive script will follow soon.

### Improvement ideas?
Sure, issues are there to be used.

### Included is?
- phpws: https://github.com/Devristo/phpws
- php-webserver: https://code.google.com/p/php-webserver/
- pthreads: https://github.com/krakjoe/pthreads
- libcurl 7.32
- Chromium 32 (Customized)
- the stuff from the other packages :)