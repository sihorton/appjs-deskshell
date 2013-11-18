
; Requires marquee plug-in
; Displays text on the splash window

!define IMG_NAME catch.ver.gif

Name "AdvSplash Version test"
OutFile "NewAdvSplash.exe"

!include WinMessages.nsh

Function .onInit

    InitPluginsDir
    SetOutPath "$PLUGINSDIR"

    File "${IMG_NAME}"
    newadvsplash::show /NOUNLOAD 3000 1000 500 -2 /BANNER /NOCANCEL "$PLUGINSDIR\${IMG_NAME}"
    newadvsplash::hwnd /NOUNLOAD
    Pop $0
    Sleep 100 ; to make window visible - this case you can skip /GCOL=00ff00 parameter
    marquee::start /NOUNLOAD /left=73 /right=2 /COLOR=ff0000 /hwnd=$0 /step=0 /interval=100 /top=15 /height=35 /width=17 /start=right "v. 3.17"

FunctionEnd

Function .onGUIInit

    newadvsplash::wait
    marquee::stop
    Delete "$PLUGINSDIR\${IMG_NAME}"
    SetOutPath "$EXEDIR" ; after this system can remove PLUGINSDIR
    ShowWindow $HWNDPARENT ${SW_RESTORE}

FunctionEnd


Section
SectionEnd