# ToDo

## PHP port
- Include environment object, to compete with the logic of the nodejs port.
- Get rid of the SegFault-trick to terminate all running threads.
- Fine-tune the webserver, try out to use PHP's internal webserver even... (php -s)
- Provide appIO.
- Create better implementation for the Events. Needs reading about shared resources in pthreads...
- Consider shooting the webserver off the scope and into a daemon, which is easier terminatable. (Terminatable... O.o; )

## General
- Start notating .d0v files into the bundle to make it detectable by the drag0n prototype.
- Re-implement CocoaDialog, write simple and small nodejs/php extension to connect with it.
