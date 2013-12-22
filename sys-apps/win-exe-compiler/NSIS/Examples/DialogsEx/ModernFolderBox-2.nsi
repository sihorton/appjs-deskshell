!include "dialogs.nsh"

Name "ModernFolderBox-2"
OutFile ModernFolderBox-2.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: none (end user's default folder dialog)
# 2) Caption: none
# 3) InitDir: none
# 4) Return: $R0
${ModernFolderBox} "" "" "" ${VAR_R0}
FunctionEnd

Section
# See if the user selects a folder:
${if} $R0 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $R0"
${endif}
SectionEnd