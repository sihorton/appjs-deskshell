!include "dialogs.nsh"

Name "InputTextBox-3"
OutFile InputTextBox-3.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS dialog title"
# 2) Caption: none
# 3) InitText: none
# 4) Max: 15
# 5) Button1: default
# 6) Button2: default
# 7) Return: $0
${InputTextBox} "NSIS dialog title" "Please, input some stuff" "" "15" "" "" 0
FunctionEnd

Section
# See if the user inputs something:
${if} $0 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $0"
${endif}
SectionEnd