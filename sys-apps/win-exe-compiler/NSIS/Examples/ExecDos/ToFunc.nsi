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
; Our function to be called
Function LogFunction
  IntOp $1 $1 + 1
  Pop $2
  MessageBox MB_OK "Output line #$1: $2"
FunctionEnd


;--------------------------------
; Installer Sections

Section "Dummy Section" SecDummy

    StrCpy $1 0

    DetailPrint "Executing console application" 
; async launch
    GetFunctionAddress $0 LogFunction
    ExecDos::exec /ASYNC /TOFUNC /TIMEOUT=5000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" $0
    Pop $0 ; thread handle for 'wait'

; execute NSIS code here if you want

; time to check process exit code (optional)
    ExecDos::wait $0

SectionEnd
