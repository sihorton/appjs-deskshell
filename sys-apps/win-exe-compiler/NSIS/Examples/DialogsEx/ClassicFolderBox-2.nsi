!include "dialogs.nsh"

Name "ClassicFolderBox-2"
OutFile ClassicFolderBox-2.exe
XPStyle on
InstallDir $EXEDIR
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: none (end user's default folder dialog title)
# 2) Caption: "Current Folder"
# 3) InitDir: "C:\"
# 4) Return: $INSTDIR
${ClassicFolderBox} "" "Current Folder:" "C:\" ${VAR_INSTDIR}
FunctionEnd

Section
Detailprint "Current INSTALL DIR:"
DetailPrint $EXEDIR
# See if the user selects a folder:
${if} ${VAR_INSTDIR} == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "New INSTALL DIR: $INSTDIR"
${endif}
SectionEnd