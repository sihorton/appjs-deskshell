!include "dialogs.nsh"

Name "OpenBox-4"
OutFile "OpenBox-4.exe"
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: None (end-user's default)
# 2) Filter: "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||"
# 3) FilterIndex: 3 (start the index in "All supported")
# 4) InitDir: $WINDIR
# ### not implemented 5) AllowMultipleFiles: 1
# 6) Style: 3 (OS default)
# 7) Return: $3
# Note: if the value of "AllowMultipleFiles" is "1", the return value store the directory and the files, separated by "|"
${OpenBox} "" "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||" 3 "$INSTDIR" 3 ${VAR_3}
FunctionEnd

Section
# See if the user selects a file:
${if} $3 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $3"
${endif}

${OpenBox} "" "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||" 3 "$INSTDIR" 1 ${VAR_3}
${if} $3 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $3"
${endif}

${OpenBox} "" "NSIS script (*.nsi)|*.nsi|NSIS header (*.nsh)|*.nsh|All supported (*.nsi;*.nsh)|*.nsi;*.nsh|All files (*.*)|*.*||" 3 "$INSTDIR" 2 ${VAR_3}
${if} $3 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $3"
${endif}

SectionEnd