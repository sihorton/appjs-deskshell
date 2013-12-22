!define APP_NAME Multi
!define DOS_APP consApp.exe

Name "${APP_NAME} Test"
OutFile "${APP_NAME}.exe"


  !include "MUI2.nsh"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"

Section "Dummy Section" SecDummy

; async launch, application sleeps 1 sec while bat is executing (see consApp.cpp)
    ExecDos::exec /NOUNLOAD /ASYNC "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" "$EXEDIR\stdout1.txt"
    Pop $0 ; consApp.exe thread handle for 'wait'
; sync launch (may be async as well, but with 'ExecDos::wait /NOUNLOAD $1' and 'Pop $1' this case)
    ExecDos::exec /NOUNLOAD "$EXEDIR\first.bat" "" "$EXEDIR\stdout2.txt"
    Pop $1 ; bat exit code
    ExecDos::wait $0 ; consApp.exe handle
    Pop $0 ; return value - consApp.exe exit code or error or STILL_ACTIVE (0x103).
; normal exit code is 5 for consApp.exe, 0 for bat. log files have additional info
    MessageBox MB_OK "Exit code bat=$1, exe=$0"

SectionEnd
