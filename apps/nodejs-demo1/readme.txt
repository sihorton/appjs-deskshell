nodejs-demo1
============

* freeport module used so that unlimited numbers of apps can be run side by side.
* application now launched from an app.nsr script, in windows associate ".nsr" with nodejs and then clicking on the file will launch the application.
* application passes the initial url to chrome binary when starting it.

This is a demo of various ways of connecting the chrome application to the backend.

1) app.nsr opens the chrome browser so it can pass parameters to it.

2) app.nsr opens a port and serves the contents of "content/" directory, navigating to /page1.htm will display the contents of content/page1.htm. This provides simple webserver functionality. In this simple demo clicking on the links will navigate you from page to page.

3) the remote debug interface is opened so application can control chrome.

4) A socket is created by app.nsr this socket is connected to from the demo application. Two way communication is then possible by sending messages from the application to the server.
	a) Click "Hello Backend" to send a message to app.nsr, it responds with a message that is popped up in the browser window.
	b) Click "ControlMe" to send message to app.nsr this will then re-direct the browser to appjs.com and after 5 seconds return back to the application.
	

All of this functionality could be wrapped up so that it is provided by a support library.

