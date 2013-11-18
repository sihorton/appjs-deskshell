!include "dialogs.nsh"

Name "SaveBox-3"
OutFile "SaveBox-3.exe"
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: None (end-user's default)
# 2) Filter: "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||"
# 3) FilterIndex: 3 (start the index in "All supported")
# 4) InitDir: $WINDIR
# 5) Style: 1 (classic style)
# 6) Return: $9
${SaveBox} "" "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||" 3 "$WINDIR" 1 ${VAR_9}
FunctionEnd

Section
# See if the user selects a file:
${if} $9 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $9"
${endif}
SectionEnd