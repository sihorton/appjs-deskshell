/**
* check for updated installer and run it.
*/
!define PRODUCT_NAME "deskshell-updater"
!define PRODUCT_VERSION "0.1"
!define PRODUCT_PUBLISHER "sihorton"
;url directly to github repository to find updated installer.
!define NEW_VERSION_URL "http://raw.github.com/sihorton/appjs-deskshell/master/installer/win/installer-version.txt"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "MUI2.nsh"
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"

!define MUI_TEXT_INSTALLING_TITLE "Downloading"
!define MUI_TEXT_INSTALLING_SUBTITLE "Please wait while ${PRODUCT_NAME} is being downloaded."

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!include "deskshell-updater-supportfn.nsi"

RequestExecutionLevel admin
Caption "${PRODUCT_NAME}"
Name "${PRODUCT_NAME}"
OutFile "../${PRODUCT_NAME}.exe"
Icon "deskshell-updater.ico"
ShowInstDetails hide

Section "MainSection" SEC01
    SetAutoClose true
    Var /GLOBAL MyPath
    Var /GLOBAL AvailableVersion
    Var /GLOBAL NewInstaller



    Push "$EXEPATH"
    Call GetParent
    Pop $MyPath

    IfFileExists "$TEMP\version-test.txt" testinstall normalinstall
    testinstall:
    FileOpen $4 "$TEMP\version-test.txt" r
    FileRead $4 $AvailableVersion
    FileRead $4 $NewInstaller
    FileClose $4
    goto getinstaller

    normalinstall:
    ;download version info

    inetc::get /SILENT  "${NEW_VERSION_URL}" "$TEMP\version-latest.txt"

    ;get versions
    IfFileExists "$TEMP\version-latest.txt" +1 nothingnew
    FileOpen $4 "$TEMP\version-latest.txt" r
    FileRead $4 $AvailableVersion
    FileRead $4 $NewInstaller
    FileClose $4

    getinstaller:
messageBox MB_OK "$NewInstaller"
    inetc::get "$NewInstaller" "$TEMP\${PRODUCT_NAME}.exe"
    Pop $0
    StrCmp $0 "OK" doinstall error
    error:
     MessageBox MB_OK "Error:$1 when downloading $NewInstaller"
     Abort

    doinstall:
    ;run uninstaller.
      ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
      IfFileExists $R0 +1 RunUpdate
      ExecWait '"$R0" /S _?=$INSTDIR'
      RunUpdate:
      Exec '$TEMP\UpdateInstall.exe'
      Quit
nothingnew:

SectionEnd