!include "dialogs.nsh"

Name "InputPwdBox-3"
OutFile InputPwdBox-3.exe
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
${InputPwdBox} "NSIS dialog title" "Please, input some stuff" "" "15" "" "" 0
FunctionEnd

Section
# See if the user inputs a valid password:
${if} $0 != "nsis"
DetailPrint "Access denied!"
${else}
DetailPrint "You may continue....!"
${endif}
SectionEnd