;--------------------------------
; ExecDos plug-in Script Sample
; Takhir Bedertdinov


;--------------------------------
; Base names definition

  !define APP_NAME "ExecDos ToStack"
  !define DOS_APP consApp.exe


;--------------------------------
; General Attributes

Name "${APP_NAME} Test"
OutFile "${APP_NAME}.exe"


;--------------------------------
; Interface Settings

  !include "MUI2.nsh"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"


;--------------------------------
; Installer Sections

Section "Dummy Section" SecDummy

    DetailPrint "Executing console application" 
; async launch
    ExecDos::exec /ASYNC /TOSTACK /TIMEOUT=5000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n"
    Pop $0 ; thread handle for 'wait'

; you can add installation code here, for example
    Sleep 1000
    DetailPrint "Installing Software"
    Sleep 1000
    DetailPrint "Installing More Software"
    Sleep 1000

; time to check process exit code (optional)
    ExecDos::wait $0

    Pop $0 ; return value - process exit code or error or STILL_ACTIVE (0x103).
; normal exit code is 5 for consApp.exe
    MessageBox MB_OK "Exit code $0"

    StrCpy $2 ""
loop:
    Pop $1
    IfErrors show
    StrCpy $2 "$1$\n$2"
    GoTo loop
show:
    MessageBox MB_OK "$2"

SectionEnd
