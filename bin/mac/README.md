# The Mac port

Hey, this is my, Ingwie Phoenix's, area of the appjs-deskshell project! In here, you will find the binaries needed for Mac to have a clean port. To use the included chromium, you need to

    tar xvfz Chromium.app.tgz

And that should do it.

## What to add? (ToDo)
- Chromium package needs to become the new deskshell.app bundle.
- Adding PHP-backend (will require pthreads)
- Implementing recent changes
- Applying Info.plist hacks to provide a nicer integration. :)
- Some under-the-hood hacks all around and about...

### PHP backend?
Yup. Me, as an enthusiastic PHP developer am planning to bring deskshell to PHP too, together with my own API layer appIO. That however is only the current name, as it is a little bit like socket.io, just changed and customized and selfmade to serve a userland object to interact with the desktop.