!include "dialogs.nsh"

Name "ModernFolderBox-1"
OutFile ModernFolderBox-1.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "Looking for something"
# 2) Caption: none
# 3) InitDir: "$EXEDIR"
# 4) Return: $R0
${ModernFolderBox} "Looking for something" "" $EXEDIR ${VAR_R0}
FunctionEnd

Section
# See if the user selects a folder:
${if} $R0 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $R0"
${endif}
SectionEnd