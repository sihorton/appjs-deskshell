!include "dialogs.nsh"

Name "ModernFolderBox-3"
OutFile ModernFolderBox-3.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: none (end user's default folder dialog)
# 2) Caption: none
# 3) InitDir: $SYSDIR
# 4) Return: $R0
${ModernFolderBox} "" "" "$SYSDIR" ${VAR_R0}
FunctionEnd

Section
# See if the user selects a folder:
${if} $R0 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $R0"
${endif}
SectionEnd