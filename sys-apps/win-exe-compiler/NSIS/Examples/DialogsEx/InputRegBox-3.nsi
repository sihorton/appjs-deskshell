!include "dialogs.nsh"

Name "InputRegBox-3"
OutFile InputRegBox-3.exe
XPStyle on
;ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS' registration dialog"
# 2) Caption: "Please give the registration$\r$\ndetails"
# 3) Caption1: "Username:"
# 4) InitCaption1: none
# 5) Max: 5
# 6) keycode: "nsis"
# 7) Caption2: "Code:"
# 8) Button1: none
# 9) Button2: none
# 10) Return: $1
Loop:
${InputRegBox} "NSIS' registration dialog" "Please give the registration$\r$\ndetails" "Username:" "" "5" "nsis" "Serial:" "" "" ${VAR_1}
# See if the user inputs a valid password:
${if} $1 == "${ISFALSE}"
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