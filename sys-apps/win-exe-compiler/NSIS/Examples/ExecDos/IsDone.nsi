;--------------------------------
; ExecDos plug-in Script Sample
; Takhir Bedertdinov


;--------------------------------
; Base names definition

  !define APP_NAME "ExecDos IsDone"
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

; $R1 - process status, 1 = exited, 0 = still running
; $R7 - Exit code
; $R9 - thread handle



;--------------------------------
; Installer Sections

Section "Dummy Section" SecDummy

  SetDetailsView show

; async launch to detailed  - no last parameter.
  DetailPrint "Executing console application, async mode" 
  ExecDos::exec /NOUNLOAD /ASYNC /DETAILED /TIMEOUT=6000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n"
  Pop $R9 ; thread handle for 'wait'
  ExecDos::isdone /NOUNLOAD $R9
  Pop $R1
  DetailPrint "isdone returned $R1" 
  Sleep 5000
  ExecDos::isdone /NOUNLOAD $R9
  Pop $R1
  DetailPrint "isdone returned $R1" 
; some other code may be here
; time to check process exit code (optional)
  ExecDos::wait $R9
  Pop $R7

; normal exit code is 5 for consApp.exe
  DetailPrint "Exit code $R7" 


SectionEnd

