/**
* check for updated installer and run it.
*/
!include "..\common\config.nsi"
!define PRODUCT_NAME "deskshell-updater"
!define PRODUCT_UPDATE_NAME "deskshell"

;url directly to github repository to find updated installer.
!define NEW_VERSION_URL "http://raw.github.com/sihorton/appjs-deskshell/master/installer/win/common/installer-version.txt"
!define UPDATE_NAME "deskshell-update-installer"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"




!define MUI_TEXT_INSTALLING_TITLE "Downloading"
!define MUI_TEXT_INSTALLING_SUBTITLE "Please wait while ${PRODUCT_UPDATE_NAME} is being downloaded."

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!include "deskshell-updater-supportfn.nsi"

RequestExecutionLevel admin
;RequestExecutionLevel user
Caption "${PRODUCT_NAME}"
Name "${PRODUCT_NAME}"
OutFile "../${PRODUCT_NAME}.exe"
Icon "deskshell-updater.ico"
ShowInstDetails hide

Section "MainSection" SEC01
    SetAutoClose true
    Var /GLOBAL MyPath
    Var /GLOBAL InstalledVersion
    Var /GLOBAL AvailableVersion
    Var /GLOBAL NewInstaller



    Push "$EXEPATH"
    Call GetParent
    Pop $MyPath

    Push "NOUPDATE"      ; push the search string onto the stack
    Push "checkupdates"   ; push a default value onto the stack
    Call GetParameterValue
    Pop $2

    StrCmp $2 "checkupdates" checkupdates nothingnew
checkupdates:
;download version info
    inetc::get /SILENT  "${NEW_VERSION_URL}" "$TEMP\version-latest.txt"


    ;get versions
    IfFileExists "$MyPath\version-test.txt" testinstall normalinstall
testinstall:
    FileOpen $4 "$MyPath\version-test.txt" r
    FileRead $4 $AvailableVersion
    FileRead $4 $NewInstaller
    FileClose $4
    goto versioncompare

normalinstall:
    IfFileExists "$TEMP\version-latest.txt" +1 nothingnew
    FileOpen $4 "$TEMP\version-latest.txt" r
    FileRead $4 $AvailableVersion
    FileRead $4 $NewInstaller
    FileClose $4

    
    
versioncompare:

    FileOpen $5 "$MyPath\version.txt" r
    FileRead $5 $InstalledVersion
    FileClose $5
    ${Trim} $AvailableVersion $AvailableVersion
    ;MessageBox MB_OK "Installed Version: $InstalledVersion Available: $AvailableVersion $NewInstaller"

    ${VersionCompare} "$InstalledVersion" "$AvailableVersion" $0
    StrCmp $0 "2" +1 nothingnew
    MessageBox MB_YESNO "A new version ($AvailableVersion) of ${PRODUCT_UPDATE_NAME} is available. Would you like to download it?" IDYES +1 IDNO leave


;;;;;;;;;;;;;;;;;;;;;;;
    ;IfFileExists "$TEMP\version-test.txt" testinstall normalinstall
    ;testinstall:
    ;FileOpen $4 "$TEMP\version-test.txt" r
    ;FileRead $4 $AvailableVersion
    ;FileRead $4 $NewInstaller
    ;FileClose $4
    ;goto getinstaller

    getinstaller:

    inetc::get "$NewInstaller" "$TEMP\${UPDATE_NAME}.exe"
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
      Exec '$TEMP\${UPDATE_NAME}.exe'
      Quit
nothingnew:
      MessageBox MB_OK "You have the latest version."
leave:
SectionEnd