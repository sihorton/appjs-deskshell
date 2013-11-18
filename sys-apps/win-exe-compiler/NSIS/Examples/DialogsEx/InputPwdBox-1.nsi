!include "dialogs.nsh"

Name "InputPwdBox-1"
OutFile InputPwdBox-1.exe
XPStyle on
;ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS dialog title"
# 2) Caption: "Please, input some stuff"
# 3) InitText: none
# 4) Max: 5
# 5) Button1: default
# 6) Button2: default
# 7) Return: $0
Loop:
${InputPwdBox} "NSIS dialog title" "Please, input some stuff" "" "5" "" "" 0
# See if the user inputs a valid password:
${if} $0 != "nsis"
MessageBox MB_ICONSTOP|MB_YESNO "Access denied!!!$\r$\nContinue?" IDYES Loop
Goto End
${else}
MessageBox MB_ICONINFORMATION|MB_OK "You may continue"
${endif}
End:
Quit
FunctionEnd

Section

SectionEnd