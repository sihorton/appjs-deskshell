!include "dialogs.nsh"

Name "InputTextBox-2"
OutFile InputTextBox-2.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS dialog title"
# 2) Caption: "Please, input some stuff"
# 3) InitText: "(no caps please!)"
# 4) Max: 5
# 5) Button1: default
# 6) Button2: default
# 7) Return: $0
${InputTextBox} "NSIS dialog title" "Please, input some stuff" "(no caps please!)" "5" "" "" 0
FunctionEnd

Section
# See if the user inputs something:
${if} $0 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $0"
${endif}
SectionEnd