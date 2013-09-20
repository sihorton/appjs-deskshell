/**
* launch boot2gecko and check for updates.
*/
/**
* temporary code to launch deskshell
*/

!include "..\common\config.nsi"
!define PRODUCT_NAME "deskshell"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "MUI2.nsh"
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!include "SupportFunctions.nsi"

RequestExecutionLevel user
Name "${PRODUCT_NAME}"
OutFile "..\deskshell.exe"
Icon "deskshell.ico"
ShowInstDetails hide

Function .onInit
    SetSilent silent
 FunctionEnd

Section "MainSection" SEC01
    Var /GLOBAL MyPath
    Var /GLOBAL InstalledVersion
    Var /GLOBAL AvailableVersion
    Var /GLOBAL NewInstaller

    ;HideWindow
    Push "$EXEPATH"
    Call GetParent
    Pop $MyPath
    
     Call GetParameters
     Pop $2

    Exec '$MYPATH\node.exe $2'
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