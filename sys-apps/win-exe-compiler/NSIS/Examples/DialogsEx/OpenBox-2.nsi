!include "dialogs.nsh"

Name "OpenBox-2"
OutFile "OpenBox-2.exe"
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: None (end-user's default)
# 2) Filter: None (use default one: All files)
# 3) FilterIndex: 1
# 4) InitDir: C:\
# 5) Style: 2 (classic style)
# 6) Return: $7
${OpenBox} "" "" 1 "C:\" 2 ${VAR_7}
FunctionEnd

Section
# See if the user selects a file:
${if} $7 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $7"
${endif}
SectionEnd