!include "dialogs.nsh"

Name "SaveBox-1"
OutFile "SaveBox-1.exe"
XPStyle on
ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "Saving a TEXT file"
# 2) Filter: "Text (*.txt)|*.txt||"
# 3) FilterIndex: 1
# 4) InitDir: $EXEDIR
# 5) Style: 3 (default style)
# 6) Return: $6
${SaveBox} "Saving a TEXT file" "Text (*.txt)|*.txt||" 1 "$EXEDIR" 3 ${VAR_6}
FunctionEnd

Section
# See if the user selects a file:
${if} $6 == "${NULL}"
DetailPrint "Operation was canceled!"
${else}
DetailPrint "You choose: $6"
${endif}
SectionEnd