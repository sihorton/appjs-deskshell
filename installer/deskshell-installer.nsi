/**
* Installer for DeskShell platform.
*           https://github.com/sihorton/appjs-deskshell
*
* @author: sihorton
*/
!include "..\common\config.nsi"
!define PRODUCT_NAME "deskshell"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!macro CreateInternetShortcut FILENAME URL
WriteINIStr "${FILENAME}.url" "InternetShortcut" "URL" "${URL}"
!macroend

; Welcome page
!insertmacro MUI_PAGE_WELCOME

; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!define MUI_DIRECTORYPAGE_TEXT_TOP 'If installing b2g-desktop then select the directory to install to. If you have selected to only instal Gaia UI to an existing b2g-desktop client then select the directory where b2g is installed on your machine.'
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "deskshell"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_TEXT "In b2g-desktop Press [Home] key to return to the homescreen after launching an app."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Run ${PRODUCT_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION "Launch-b2g"
;!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\${PROFILE_DIR_DEST}\install-readme.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES


; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "..\${PRODUCT_NAME}_${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails hide
ShowUnInstDetails hide

Function .onInit
  Var /GLOBAL DelDir
  ;try to see if it is running--
  FindProcDLL::FindProc "deskshell.exe"
  IntCmp $R0 1 0 notRunning
    MessageBox MB_OK|MB_ICONEXCLAMATION "deskshell is running. Click ok to close the process." /SD IDOK
    KillProcDLL::KillProc "deskshell.exe"
notRunning:

  ReadRegStr $DelDir ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallDir"

; Check to see if already installed
  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  IfFileExists $R0 +1 NotInstalled
  MessageBox MB_YESNO "${PRODUCT_NAME} is already installed, should we uninstall the existing version first?$\nNo will install over the top of the existing version." IDYES Uninstall IDNO NotInstalled
Uninstall:
  ExecWait '"$R0" /S _?=$INSTDIR'
  Delete "$R0"
  RmDir "$DelDir"
NotInstalled:
FunctionEnd

Section "deskshell" SEC01
  SetShellVarContext all
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR"
  CreateDirectory "$INSTDIR"
  
  SetOutPath "$INSTDIR\sys-apps"
  File /r "apps\"

  SetOutPath "$INSTDIR"
  
  ;install version info and launch / auto update.
  File "..\common\version.txt"
  File "..\deskshell.exe"
  File "..\deskshell-updater.exe"
  ;install code
  ;File /r /x ".git" "${B2G_DIR_SRC}\"
  ;File "${PROFILE_DIR_SRC}\gkmedias.dll"

  ${registerExtension} "$INSTDIR\deskshell.exe" ".desk" "DeskShell Application"
  
; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\${PRODUCT_NAME}.lnk" "$INSTDIR\deskshell.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\deskshell.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd



Section -AdditionalIcons
  SetShellVarContext all
  SetOutPath $INSTDIR
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

  !insertmacro CreateInternetShortcut \
      "$SMPROGRAMS\$ICONS_GROUP\Website.url" \
      "https://github.com/sihorton/appjs-deskshell/"

  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  SetShellVarContext all
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\deskshell.exe"

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\deskshell.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  IfSilent +2 0
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
IfSilent silent noisy
  noisy:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
  goto ok

  silent:
  SetAutoClose true

  ok:

FunctionEnd

Section Uninstall
  SetShellVarContext all
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  RMDir /r "$SMPROGRAMS\$ICONS_GROUP"
  RMDir /r "$INSTDIR\"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

Function Launch-b2g
  ;ExecShell "" "$INSTDIR\deskshell.lnk"
  Exec "$INSTDIR\deskshell.exe /NOUPDATE"
FunctionEnd

