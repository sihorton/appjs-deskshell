/**
* launch deskshell and open console.
*/


!define PRODUCT_NAME "deskshell"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "..\common\config.nsi"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"


;!include "..\common\LogicLib.nsh"
!include "SupportFunctions.nsi"

RequestExecutionLevel user
Name "${PRODUCT_NAME}"
OutFile "..\..\..\deskshell_debug.exe"
Icon "deskshell.ico"
ShowInstDetails hide

Function .onInit
    SetSilent silent
 FunctionEnd

Section "MainSection" SEC01
    Var /GLOBAL MyPath

    ;HideWindow
    Push "$EXEPATH"
    Call GetParent
    Pop $MyPath
    
     Call GetParameters
     Pop $2

     ${If} $2 == ''
         ;Exec '"$MYPATH\bin\win\node.exe" "$MYPATH\sys-apps\env.js" "$MYPATH/sys-apps/default/default.desk"'
         Exec '"$MYPATH\bin\win\node.exe" "$MYPATH\bin\win\deskshell.js"'
        ;MessageBox MB_OK '$MYPATH\bin\win\node.exe "$MYPATH/sys-apps/default/default.desk"'
     ${Else}
         Exec '$MYPATH\bin\win\node.exe "$MYPATH\bin\win\deskshell.js" $2'
         ;MessageBox MB_OK '$MYPATH\bin\win\node.exe $2'
    ${EndIf}
    
SectionEnd

Section -AdditionalIcons
SectionEnd

Section -Post
SectionEnd


Function GetParameters

  Push $R0
  Push $R1
  Push $R2
  Push $R3

  StrCpy $R2 1
  StrLen $R3 $CMDLINE

  ;Check for quote or space
  StrCpy $R0 $CMDLINE $R2
  StrCmp $R0 '"' 0 +3
    StrCpy $R1 '"'
    Goto loop
  StrCpy $R1 " "

  loop:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 get
    StrCmp $R2 $R3 get
    Goto loop

  get:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " get
    StrCpy $R0 $CMDLINE "" $R2

  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0

FunctionEnd