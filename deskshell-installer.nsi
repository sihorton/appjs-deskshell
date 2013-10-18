/**
* Installer for DeskShell platform.
*           https://github.com/sihorton/appjs-deskshell
*
* @author: sihorton
*/
!define PRODUCT_NAME "Deskshell"

!define COMMON_DIR "installer\win\common"
!define WIN_DIR "bin\win"

!include "${COMMON_DIR}\config.nsi"
!include "${COMMON_DIR}\register-extensions.nsh"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!macro CreateInternetShortcut FILENAME URL
WriteINIStr "${FILENAME}.url" "InternetShortcut" "URL" "${URL}"
!macroend

; Welcome page
!insertmacro MUI_PAGE_WELCOME

; Components page
;!insertmacro MUI_PAGE_COMPONENTS
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Deskshell"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!define MUI_FINISHPAGE_TEXT ""
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Run ${PRODUCT_NAME} docs and demos app"
!define MUI_FINISHPAGE_RUN_FUNCTION "Launch-deskshell"
;!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\${PROFILE_DIR_DEST}\install-readme.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES


; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------
RequestExecutionLevel admin
;RequestExecutionLevel user
Name "${PRODUCT_NAME}"
;_${PRODUCT_VERSION}
OutFile "${COMMON_DIR}\..\${PRODUCT_NAME}-install.exe"
InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails hide
ShowUnInstDetails hide

Function .onInit
  Var /GLOBAL DelDir
  ;try to see if it is running--
  FindProcDLL::FindProc "deskshell.exe"
  IntCmp $R0 1 0 notRunning
    MessageBox MB_OK|MB_ICONEXCLAMATION "Deskshell is running. Click ok to close the process." /SD IDOK
    KillProcDLL::KillProc "deskshell.exe"
notRunning:

  ReadRegStr $DelDir ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallDir"

; Check to see if already installed
  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  IfFileExists $R0 +1 NotInstalled
  ;MessageBox MB_YESNO "${PRODUCT_NAME} is already installed, should we uninstall the existing version first?$\nNo will install over the top of the existing version." IDYES Uninstall IDNO NotInstalled
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
;create a little text file to tell deskshell it is the first time it is run after an install
;here we can then update the environment config and options.
;  File "${COMMON_DIR}\first-run.txt"
  
  SetOutPath "$INSTDIR\sys-apps"
  File /r /x ".git" "sys-apps\"

 CreateDirectory "$INSTDIR\bin\node_modules\"
  SetOutPath "$INSTDIR\bin\node_modules"
  File /r /x ".git" "bin\node_modules\"

  CreateDirectory "$INSTDIR\bin\win\"
  CreateDirectory "$INSTDIR\bin\win\chrome-profile\"

  SetOutPath "$INSTDIR\bin\win"
  File /r /x ".git" /x "deskshell-env.js" /x chrome-profile "bin\win\"
  File "${COMMON_DIR}\..\deskshell-updater.exe"
  File "${COMMON_DIR}\installer-version.txt"
  

;create directory for user apps.
  CreateDirectory "$LOCALAPPDATA\${PRODUCT_NAME}-apps"

  SetOutPath "$INSTDIR"
  
  ;install version info and launch / auto update.
  File "deskshell.exe"
  File "deskshell_debug.exe"
  
  ${registerExtension} "$INSTDIR\deskshell.exe" ".desk" "DeskShell Source Application"
  ${registerExtension} "$INSTDIR\deskshell.exe" ".appfs" "DeskShell Application"
  ${registerExtension} "$INSTDIR\deskshell_debug.exe" ".desk-debug" "DeskShell Application Debug"
  ${registerExtension} "$INSTDIR\deskshell_debug.exe" ".desk-back" "DeskShell Backend Application"

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\${PRODUCT_NAME}.lnk" "$INSTDIR\deskshell.exe"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\deskshell-updater.lnk" "$INSTDIR\deskshell-updater.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\deskshell.exe"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\My Deskshell Apps.lnk" "$LOCALAPPDATA\${PRODUCT_NAME}-apps"
  CreateShortCut "$LOCALAPPDATA\${PRODUCT_NAME}-apps\NewAppWizard.lnk" "$LOCALAPPDATA\${PRODUCT_NAME}\sys-apps\app-wizard\app-wizard.desk"
  CreateShortCut "$LOCALAPPDATA\${PRODUCT_NAME}-apps\Docs.lnk" "$LOCALAPPDATA\${PRODUCT_NAME}\sys-apps\demo-docs\demo-docs.desk"

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
  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\sys-apps"
  Delete "$INSTDIR\deskshell.exe"
  Delete "$INSTDIR\deskshell_debug.exe"

   ${unregisterExtension} ".desk" "DeskShell Source Application"
   ${unregisterExtension} ".appfs" "DeskShell Application"
   ${unregisterExtension} ".desk-debug" "DeskShell Application Debug"
   ${unregisterExtension} ".desk-back" "DeskShell Backend Application"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

Function Launch-deskshell
  Exec "$INSTDIR\deskshell.exe"
FunctionEnd

