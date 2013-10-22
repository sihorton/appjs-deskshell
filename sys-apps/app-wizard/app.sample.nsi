/**
* check for updated installer and run it.
*/

!define PRODUCT_NAME "deskshell-updater"
!define PRODUCT_UPDATE_NAME "deskshell"
!define DESKSHELL_INSTALL "$LOCALAPPDATA\Deskshell\Deskshell"

;url directly to github repository to find updated installer.
!define NEW_VERSION_URL "http://raw.github.com/sihorton/appjs-deskshell/master/installer/win/common/installer-version.txt"
!define UPDATE_NAME "deskshell-installer"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!include "MUI2.nsh"



!define MUI_TEXT_INSTALLING_TITLE "Downloading"
!define MUI_TEXT_INSTALLING_SUBTITLE "Please wait while ${PRODUCT_UPDATE_NAME} is being downloaded."

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

;!include "deskshell-updater-supportfn.nsi"

;RequestExecutionLevel admin
RequestExecutionLevel user
Caption "${PRODUCT_NAME}"
Name "${PRODUCT_NAME}"
OutFile "deploy/ssh.exe"
Icon "htdocs/favicon.ico"
ShowInstDetails hide

Section "MainSection" SEC01
    SetAutoClose true
    Var /GLOBAL MyPath
    Var /GLOBAL AvailableVersion
    Var /GLOBAL NewInstaller


IfFileExists '${DESKSHELL_INSTALL}.exe' DeskshellInstalled DeskshellMissing
DeskshellMissing:
MessageBox MB_YESNO 'This application requires Deskshell to be able to run. Would you like to download and install it now?' IDNO stopLaunch IDYES download
stoplaunch:
Quit
download:

;download version info
    inetc::get /SILENT  "${NEW_VERSION_URL}" "$TEMP\version-latest.txt"
    FileOpen $4 "$TEMP\version-latest.txt" r
    FileRead $4 $AvailableVersion
    FileRead $4 $NewInstaller
    FileClose $4


    inetc::get "$NewInstaller" "$TEMP\${UPDATE_NAME}.exe"
    Pop $0
    StrCmp $0 "OK" doinstall error
    error:
     MessageBox MB_OK "Error:$1 when downloading $NewInstaller. Please try again."
     Abort

    doinstall:
    ExecShell "open" '$TEMP\${UPDATE_NAME}.exe'
    Quit

DeskshellInstalled:
    ;MessageBox MB_OK '${DESKSHELL_INSTALL}.exe "$MYPATH\app.desk" $2'
    Exec '${DESKSHELL_INSTALL}.exe "$EXEDIR\app.appfs" $2'
    ;Exec '${DESKSHELL_INSTALL}.exe "$EXEPATH" $2'
SectionEnd