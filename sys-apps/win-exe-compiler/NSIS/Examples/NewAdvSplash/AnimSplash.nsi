;-----------------------------
; Requires AnimGif plug-in

Name "NewAdvSplash.dll test"
OutFile "NewAdvSplash.exe"

!define IMG_NAME aist.gif

!include "MUI.nsh"
!define MUI_CUSTOMFUNCTION_GUIINIT begin
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_LANGUAGE "English"


Function .onInit

; following 2 lines can minimize all other desktop windows
;    FindWindow $0 "Shell_TrayWnd"
;    SendMessage $0 ${WM_COMMAND} 415 0

;  the plugins dir is automatically deleted when the installer exits
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"


;  Modeless banner sample: show + wait
    File "aist.gif"
    newadvsplash::show /NOUNLOAD 2000 1000 500 -1 /BANNER "$PLUGINSDIR\${IMG_NAME}"
    newadvsplash::hwnd /NOUNLOAD
    Pop $0
    AnimGif::play /NOUNLOAD /hwnd=$0 /bgcol=0xffffff "$PLUGINSDIR\${IMG_NAME}"

; you can add some background initialization code here (3.5 sec)

FunctionEnd


Function begin

    newadvsplash::wait     ; waits or exits immediately if 'show' already finished
    AnimGif::stop

    Delete "$PLUGINSDIR\${IMG_NAME}"
    SetOutPath "$EXEDIR"

;  plug-in requires this to be called in .onGUIInit in the BANNER mode only
    ShowWindow $HWNDPARENT ${SW_RESTORE}

FunctionEnd


Section
SectionEnd
