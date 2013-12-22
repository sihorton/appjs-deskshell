!include "dialogs.nsh"

Name "SaveBox-2"
OutFile "SaveBox-2.exe"
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: None (end-user's default)
# 2) Filter: None (use default one: All files)
# 3) FilterIndex: 1
# 4) InitDir: C:\
# 5) Style: 2 (classic style)
# 6) Return: $R2
${SaveBox} "" "" 1 "C:\" 2 ${VAR_R2}
FunctionEnd

Section
# See if the user selects a file:
${if} $R2 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $R2"
${endif}
SectionEnd