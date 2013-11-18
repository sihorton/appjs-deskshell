!include "dialogs.nsh"

Name "ClassicFolderBox-3"
OutFile ClassicFolderBox-3.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: none (end user's default folder dialog title)
# 2) Caption: none
# 3) InitDir: none
# 4) Return: $3
${ClassicFolderBox} "" "" "" ${VAR_3}
FunctionEnd

Section
# See if the user selects a folder:
${if} $3 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $3"
${endif}
SectionEnd