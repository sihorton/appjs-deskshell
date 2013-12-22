!include "dialogs.nsh"

Name "InputRegBox-1"
OutFile InputRegBox-1.exe
XPStyle on
;ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS' registration dialog"
# 2) Caption: "Please give the registration$\r$\ndetails"
# 3) Caption1: "Username:"
# 4) InitCaption1: (no caps!)
# 5) Max: 20
# 6) keycode: "lobo"
# 7) Caption2: "Code:"
# 8) Button1: Do it
# 9) Button2: Abort
# 10) Return: $4
Loop:
${InputRegBox} "NSIS' registration dialog" "Please give the registration$\r$\ndetails" "Username:" "(no caps!)" "20" "lobo" "Serial:" "Do it" "Abort" ${VAR_4}
# See if the user inputs a valid password:
${if} $4 == "${ISFALSE}"
MessageBox MB_OK "generatedCode=[$0], username=[$1], usercode=[$2], keycode=[$3], result=[$4]"
MessageBox MB_ICONSTOP|MB_YESNO "Access denied!!!$\r$\nContinue?" IDYES Loop
Goto End
${else}
MessageBox MB_ICONINFORMATION|MB_OK "You may continue"
${endif}
End:
Quit
FunctionEnd

Section

SectionEnd