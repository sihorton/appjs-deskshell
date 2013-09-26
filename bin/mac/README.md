# The Mac port

Hey, this is my, Ingwie Phoenix's, area of the appjs-deskshell project! In here, you will find the binaries needed for Mac to have a clean port. To use the included chromium, you need to

    tar xvfz deskshell.mac.tgz

And that should do it.

## What to add? (ToDo)
- Adding PHP-backend (will require pthreads)

### PHP backend?
Yup. Me, as an enthusiastic PHP developer am planning to bring deskshell to PHP too, together with my own API layer appIO. That however is only the current name, as it is a little bit like socket.io, just changed and customized and selfmade to serve a userland object to interact with the desktop.

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