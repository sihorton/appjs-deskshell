/**
* Change settings below to set information about your application. 
* Uncomment VIAddVersionKey lines if needed.
* This file is an nsis installer file. http://nsis.sourceforge.net/
*/
!define PRODUCT_NAME "DeskshellApp"
!define PRODUCT_VERSION "0.1.0"
!define PRODUCT_PUBLISHER "sihorton"
!define PRODUCT_WEB_SITE "http://github.com/sihorton/appjs-deskshell"
VIProductVersion "${PRODUCT_VERSION}.0.0"
VIAddVersionKey ProductName "${PRODUCT_NAME}"
VIAddVersionKey Comments "Deskshell - desktop applications built with html5 technology."
;VIAddVersionKey CompanyName company
;VIAddVersionKey LegalCopyright legal
VIAddVersionKey FileDescription "${PRODUCT_NAME}"
VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey InternalName "${PRODUCT_NAME}"
;VIAddVersionKey LegalTrademarks ""
VIAddVersionKey OriginalFilename "${PRODUCT_NAME}.exe"

;executable name
OutFile "deploy/app.exe"
;icon to use for your executable
Icon "htdocs/favicon.ico"



/**
* Deskshell install information, no need to change.
*/
!define PRODUCT_UPDATE_NAME "deskshell"
!define DESKSHELL_INSTALL "$LOCALAPPDATA\Deskshell\Deskshell"
!define NEW_VERSION_URL "http://raw.github.com/sihorton/appjs-deskshell/master/installer/win/common/installer-version.txt"
!define UPDATE_NAME "deskshell-installer"

!include "MUI2.nsh"
!define MUI_TEXT_INSTALLING_TITLE "Downloading"
!define MUI_TEXT_INSTALLING_SUBTITLE "Please wait while ${PRODUCT_UPDATE_NAME} is being downloaded."
!insertmacro MUI_LANGUAGE "English"

RequestExecutionLevel user
Caption "${PRODUCT_NAME}"
Name "${PRODUCT_NAME}"
ShowInstDetails hide

Function .onInit
	;This code will detect if deskshell is installed
	;No need to edit this code.
    IfFileExists '${DESKSHELL_INSTALL}.exe' DeskshellInstalled DeskshellMissing
DeskshellInstalled:
    Exec '${DESKSHELL_INSTALL}.exe "$EXEPATH" $2'
	;To run your app with a console (debug) window comment out the above line and uncomment the below line.
    ;Exec '${DESKSHELL_INSTALL}_debug.exe "$EXEPATH" $2'
    Quit
DeskshellMissing:
; continue to rest of the installer.
FunctionEnd

Section "MainSection" SEC01
	;This code will download install deskshell and then run your application.
	;No need to change this code.

    SetAutoClose true
    Var /GLOBAL AvailableVersion
    Var /GLOBAL NewInstaller

    MessageBox MB_YESNO 'This application requires Deskshell to be able to run. Would you like to download and install it now?' IDNO stopLaunch IDYES download
stoplaunch:
    Quit
download:
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

SectionEnd

