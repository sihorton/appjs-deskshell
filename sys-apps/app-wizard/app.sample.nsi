/**
* Custom application executable.
*/

;enter in your application info here
!define PRODUCT_NAME "Deskshell App"
!define PRODUCT_VERSION "0.1.0"
!define PRODUCT_PUBLISHER "Deskshell Demos"
!define PRODUCT_WEB_SITE "http://github.com/sihorton/appjs-deskshell"
OutFile "app.exe"
Icon "app.ico"

VIProductVersion "${PRODUCT_VERSION}.0.0"
VIAddVersionKey ProductName "${PRODUCT_NAME}"
VIAddVersionKey Comments "Deskshell - desktop applications built with html5 technology."
;VIAddVersionKey CompanyName company
;VIAddVersionKey LegalCopyright legal
VIAddVersionKey FileDescription "${PRODUCT_NAME}"
VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey InternalName "${PRODUCT_NAME}"
;VIAddVersionKey LegalTrademarks ""
VIAddVersionKey OriginalFilename "${PRODUCT_NAME}.exe"


;should not need to modify anything after this line.
;!insertmacro MUI_PAGE_INSTFILES
;!insertmacro MUI_LANGUAGE "English"
;!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define DESKSHELL_INSTALL "$LOCALAPPDATA\Deskshell\Deskshell"

RequestExecutionLevel user
Name "${PRODUCT_NAME}"

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


    ;MessageBox MB_OK '${DESKSHELL_INSTALL}.exe "$MYPATH\app.desk" $2'
    Exec '${DESKSHELL_INSTALL}.exe "$MYPATH\app.desk" $2'

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
Function GetParent

  Exch $R0
  Push $R1
  Push $R2
  Push $R3

  StrCpy $R1 0
  StrLen $R2 $R0

  loop:
    IntOp $R1 $R1 + 1
    IntCmp $R1 $R2 get 0 get
    StrCpy $R3 $R0 1 -$R1
    StrCmp $R3 "\" get
  Goto loop

  get:
    StrCpy $R0 $R0 -$R1

    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0
FunctionEnd