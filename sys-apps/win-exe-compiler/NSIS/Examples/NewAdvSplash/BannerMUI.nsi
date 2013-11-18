
Name "NewAdvSplash.dll test"
OutFile "NewAdvSplash.exe"


!include "MUI.nsh"
!define MUI_CUSTOMFUNCTION_GUIINIT MUIGUIInit
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_LANGUAGE "English"

!define IMG_NAME aist.gif

Function .onInit

;  the plugins dir is automatically deleted when the installer exits
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"

;  Modeless banner sample: show + wait
    File ${IMG_NAME}
    newadvsplash::show /NOUNLOAD 2000 1000 500 -2 /BANNER "$PLUGINSDIR\${IMG_NAME}"
    Sleep 2000 ; not changes 3.5 sec of 'show time'. add your code instead of sleep

FunctionEnd


; MUI requires custom function definition
Function MUIGUIInit

    newadvsplash::wait ; waits or exits immediately if finished, use 'stop' to terminate

    Delete "$PLUGINSDIR\${IMG_NAME}"
    SetOutPath "$EXEDIR"

;  plug-in requires this to be called in .onGUIInit
;  if you use 'show' in the .onInit function with /BANNER key.
    ShowWindow $HWNDPARENT ${SW_RESTORE}

FunctionEnd


Section
SectionEnd