
Name "NewAdvSplash.dll test"
OutFile "NewAdvSplash.exe"

!define IMG_NAME1 splash.bmp
!define IMG_NAME2 aist.gif

!include WinMessages.nsh


Function .onInit

;  the plugins dir is automatically deleted when the installer exits
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"

;  optional - mp3, use /LOOP key for 'non-stop'
#    File "09.mp3"
#    newadvsplash::play /NOUNLOAD "$PLUGINSDIR\09.mp3"

;  Modal banner sample: show
    File "/oname=$PLUGINSDIR\${IMG_NAME1}" "${NSISDIR}\Contrib\Graphics\Wizard\llama.bmp"
    newadvsplash::show 1000 100 500 0x04025C /NOCANCEL "$PLUGINSDIR\${IMG_NAME1}"
    Delete "$PLUGINSDIR\${IMG_NAME1}"
    Sleep 500 ; optional

;  Modeless banner sample: show + wait
    File ${IMG_NAME2}
    newadvsplash::show /NOUNLOAD 2000 1000 500 -2 /BANNER "$PLUGINSDIR\${IMG_NAME2}"
    Sleep 2000 ; not changes 3.5 sec of 'show time'. add your code instead of sleep

FunctionEnd


; MUI requires custom function definition
Function .onGUIInit

    newadvsplash::wait ; waits or exits immediately if finished, use 'stop' to terminate

    Delete "$PLUGINSDIR\${IMG_NAME2}"
    SetOutPath "$EXEDIR"

;  plug-in requires this to be called in .onGUIInit
;  if you use 'show' in the .onInit function with /BANNER key.
    ShowWindow $HWNDPARENT ${SW_RESTORE}

FunctionEnd


Section
SectionEnd