!include "dialogs.nsh"

Name "InputPwdBox-2"
OutFile InputPwdBox-2.exe
XPStyle on
;ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS dialog title"
# 2) Caption: "Please, input some stuff"
# 3) InitText: none
# 4) Max: 15
# 5) Button1: "Do it"
# 6) Button2: "Abort"
# 7) Return: $0
${InputPwdBox} "NSIS dialog title" "Please, input some stuff" "" "15" "Do it" "Abort" 0
# See if the user inputs a valid password:
${if} $0 != "nsis"
MessageBox MB_ICONSTOP|MB_OK "Access denied"
${else}
MessageBox MB_ICONINFORMATION|MB_OK "You may continue"
${endif}
Quit
FunctionEnd

Section

SectionEnd