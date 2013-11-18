Deskshell
=========

Deskshell is a SDK that provides a shell (as in egg shell) around web applications so that they can run on the 
desktop. It gives you a modern HTML5 / CSS / JS frontend for your user interface, but then allows full backend 
functionality written in popular server scripting languages that anyone can pick up like node or php 
(more choices coming soon). This makes it possible to read and write directly to disk, 
access databases, communicate with servers and solve the task at hand.

Try it out now with the following download:
+ [Windows](http://deskshell.org?download=WindowsInstall)
+ [MacOS](http://deskshell.org?download=MacInstall)
+ Linux coming soon.

Community:
========
We are a very diverse community that welcomes people who have english as a second language. We are open and welcoming
to new people both experienced super hackers and newbies alike. We would love this project
to be your first accepted commit to an open source project. 
There are also many things that are not strictly coding that you
can do, maybe you can write an example app, improve our documentation, answer questions on the forums or write a 
tutorial. Mostly just have fun making apps and when you see something that could be better have a go at improving
it and then share it with the community.

Join us on the [mailing list](https://groups.google.com/d/forum/appjs-dev)

Source Code:
========

The quickest way to start is to download the distributable for your platform and try making some applications. 
The distributable will launch an example application that also serves as documentation and guide for the project.
To get deskshell source code, clone the repository and get all submodules.

    git clone https://github.com/sihorton/appjs-deskshell.git deskshell
    cd deskshell
    git submodule init
    
If you want to get the latest versions of the node modules deskshell uses then run:

    npm update
    
    
Then look at the readme for your platform (
[Windows Readme](https://github.com/sihorton/appjs-deskshell/tree/master/bin/win) | 
[MacOS Readme](https://github.com/sihorton/appjs-deskshell/tree/master/bin/mac) | 
[Linux Readme](https://github.com/sihorton/appjs-deskshell/tree/master/bin/linux)
)

AppJS:
=======

This project grew out of the excellent work of [Milani](https://github.com/milani), [Benvie](https://github.com/Benvie) 
and others on the [appjs](https://github.com/appjs/appjs/) project. It is very similar in spirit and nature but
the source code is based in javascript rather than C++ which the majority of our users are more familiar with. This 
expands the pool of programmers that can contribute to the project and makes it more accessible for beginners. If you
have C++ skills then you are welcome to help us on creating and improving an embedded chromium frontend for deskshell.

