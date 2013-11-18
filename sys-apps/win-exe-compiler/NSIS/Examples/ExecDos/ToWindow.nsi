;--------------------------------
; ExecDos plug-in Script Sample
; Takhir Bedertdinov


;--------------------------------
; Base names definition

  !define APP_NAME "ExecDos ToWindow"
  !define DOS_APP consApp.exe


;--------------------------------
; General Attributes

Name "${APP_NAME} Test"
OutFile "${APP_NAME}.exe"


;--------------------------------
; Interface Settings

  !include "MUI2.nsh"
  !include "InstallOptions.nsh"
  Page custom CustomPageEdit
  Page custom CustomPageList
  !insertmacro MUI_PAGE_INSTFILES


  !insertmacro MUI_LANGUAGE "English"


; $R0 - enable/disable buttons flag
; $R2 - end function pointer
; $R4 - $R7 - Exit codes collection
; $R8 - target window handle
; $R9 - thread handle



;--------------------------------
; Installer Sections

Section "Dummy Section" SecDummy

  SetDetailsView show

; sync launch to window
  DetailPrint "Executing console application, sync mode" 
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $R8 $0 1016
  ExecDos::exec /TOWINDOW /TIMEOUT=6000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" $R8
  Pop $R6 ; return value - process exit code or error or STILL_ACTIVE (0x103).


; async launch to detailed  - no last parameter.
  DetailPrint "Executing console application, async mode" 
  ExecDos::exec /ASYNC /DETAILED /TIMEOUT=6000 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n"
  Pop $R9 ; thread handle for 'wait'
; some other code may be here
; time to check process exit code (optional)
  ExecDos::wait $R9
  Pop $R7

; normal exit code is 5 for consApp.exe
    MessageBox MB_OK "Exit codes $R4 $R5 $R6 $R7"


SectionEnd

Function enableNext

  GetDlgItem $0 $HWNDPARENT 1
  EnableWindow $0 $R0
  GetDlgItem $0 $HWNDPARENT 2
  EnableWindow $0 $R0
  GetDlgItem $0 $HWNDPARENT 3
  EnableWindow $0 $R0

FunctionEnd

Function CustomPageEdit

  !insertmacro MUI_HEADER_TEXT "ExecDos /TOWINDOW test" "Multiline Edit Window"
  !insertmacro INSTALLOPTIONS_EXTRACT ml_edit.ini
  !insertmacro INSTALLOPTIONS_INITDIALOG ml_edit.ini
  Pop $0
  !insertmacro INSTALLOPTIONS_READ $R8 ml_edit.ini "Field 1" HWND
  StrCpy $R0 0
  Call enableNext
  StrCpy $R0 1
  GetFunctionAddress $R2 enableNext
  ExecDos::exec /ASYNC /TOWINDOW /ENDFUNC=$R2 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" $R8
  Pop $R9
  !insertmacro INSTALLOPTIONS_SHOW

  ; Security feature.
  ExecDos::wait $R9
  Pop  $R4



FunctionEnd

Function CustomPageList

  !insertmacro MUI_HEADER_TEXT "ExecDos /TOWINDOW test" "ListBox Window"
  !insertmacro INSTALLOPTIONS_EXTRACT listbox.ini
  !insertmacro INSTALLOPTIONS_INITDIALOG listbox.ini
  Pop $0
  !insertmacro INSTALLOPTIONS_READ $R8 listbox.ini "Field 1" HWND
  StrCpy $R0 0
  Call enableNext
  StrCpy $R0 1
  ExecDos::exec /ASYNC /TOWINDOW /ENDFUNC=$R2 "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" $R8
  Pop $R9

  !insertmacro INSTALLOPTIONS_SHOW

  ExecDos::wait $R9
  Pop  $R5



FunctionEnd
