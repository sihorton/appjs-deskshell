!include "dialogs.nsh"

Name "InputRegBox-2"
OutFile InputRegBox-2.exe
XPStyle on
;ShowInstDetails show

Function .onInit
# Params:
# 1) Title: "NSIS' registration dialog"
# 2) Caption: "Please give the registration$\r$\ndetails"
# 3) Caption1: "Me:"
# 4) InitCaption1: none
# 5) Max: 7
# 6) keycode: "dome"
# 7) Caption2: "Serial:"
# 8) Button1: none
# 9) Button2: none
# 10) Return: $1
Loop:
${InputRegBox} "NSIS' registration dialog" "Please give the registration$\r$\ndetails" "Me:" "" "7" "dome" "Serial:" "" "" ${VAR_1}
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