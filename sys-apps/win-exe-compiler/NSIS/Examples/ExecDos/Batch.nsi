
!define APP_NAME BatchTest

Name "${APP_NAME} Test"
OutFile "${APP_NAME}.exe"

!include "MUI2.nsh"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"


Section "Dummy Section" SecDummy

    ExecDos::exec '"$EXEDIR\first.bat"' "" "$EXEDIR\stdout.txt"
    Pop $0
    MessageBox MB_OK "Exit code $0"

SectionEnd

