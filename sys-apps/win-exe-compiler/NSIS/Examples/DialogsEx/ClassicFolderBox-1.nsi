!include "dialogs.nsh"

Name "ClassicFolderBox-1"
OutFile ClassicFolderBox-1.exe
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "Got a folder?"
# 2) Caption: "Current Folder"
# 3) InitDir: $EXEDIR
# 4) Return: $3
${ClassicFolderBox} "Got a folder?" "Current Folder:" $EXEDIR ${VAR_3}
FunctionEnd

Section
# See if the user selects a folder:
${if} $3 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $3"
${endif}
SectionEnd