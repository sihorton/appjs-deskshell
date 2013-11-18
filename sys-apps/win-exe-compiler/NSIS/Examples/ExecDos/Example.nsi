;--------------------------------
; ExecDos plug-in Script Sample
; Takhir Bedertdinov


;--------------------------------
; Base names definition

  !define APP_NAME ExecDos
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

; entry points: 'exec' and 'wait'

; exec - starts hidden process with redirected IO
; parameters: [/NOUNLOAD /ASYNC] [/TIMEOUT=xxx] [/TOSTACK] application_to_run [stdin_string] [log_file_name]
; /ASYNC - not waits for process exit.
; timeout is TOTAL execution time, milliseconds
; for example /TIMEOUT=10000    Should be >50   Default is big enough
; short timeouts may cause -8 plug-in exit code (APPLICATION TERMINATED)
; application_to_run is mandatory, other params are optional, but if stack
; stores other vars, would be better to set "" for unused parameter
; return value in the sync mode is application' exit code
; with /ASYNC option returns thread handle

; wait - waits for process exit (with /ASYNC option only). Require thread handle. Optional if you don't need exit code.
; parameters: thread_handle. If stack is not used between 'exec' and 'wait', both Pop $0 and 'wait' param may be skipped.
; process exit code is available (Pop) after 'wait' exits.

    DetailPrint "Executing console application" 
; async launch
    ExecDos::exec /NOUNLOAD /ASYNC /TIMEOUT=5000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" "$EXEDIR\stdout.txt"
    Pop $0 ; thread handle for 'wait'

; you can add installation code here, for example
    Sleep 1000
    DetailPrint "Installing Software"
    Sleep 1000
    DetailPrint "Installing More Software"
    Sleep 1000

; time to check process exit code (optional)
    ExecDos::wait $0

; sync launch
;    ExecDos::exec /TIMEOUT=5000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" "$EXEDIR\stdout.txt"

    Pop $0 ; return value - process exit code or error or STILL_ACTIVE (0x103).
; normal exit code is 5 for consApp.exe
    MessageBox MB_OK "Exit code $0"

SectionEnd

;Function .onInit
;    ExecDos::exec /NOUNLOAD /TIMEOUT=5000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" "$EXEDIR\${APP_NAME}.log"
;    Pop $0
;    MessageBox MB_OK "Exit code $0"
;FunctionEnd
