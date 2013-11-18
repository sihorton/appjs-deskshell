!include MUI2.nsh

# EmbeddedLists example: ListView_CheckBoxes.nsi
# Uses ListView_CheckBoxes.ini
# Displays a list view dialog containing a few items,
# with check boxes.
# No items can be selected, only checked.

# Settings
Name `EmbeddedLists Plugin Example`
OutFile `ListView_CheckBoxes.exe`

# Pages
!insertmacro MUI_PAGE_WELCOME
Page Custom ListViewShow ListViewLeave
!insertmacro MUI_PAGE_COMPONENTS

# Languages
!insertmacro MUI_LANGUAGE `English`

# Reserve plugin files (good practice)
ReserveFile `ListView_CheckBoxes.ini`
ReserveFile `${NSISDIR}\Plugins\InstallOptions.dll`
ReserveFile `${NSISDIR}\Plugins\EmbeddedLists.dll`

# Callback functions
Function .onInit

 InitPluginsDir
 File `/oname=$PLUGINSDIR\ListView_CheckBoxes.ini` `ListView_CheckBoxes.ini`

 WriteINIStr `$PLUGINSDIR\ListView_CheckBoxes.ini` `Icons` `Icon1` `$EXEDIR\icon1.ico`
 WriteINIStr `$PLUGINSDIR\ListView_CheckBoxes.ini` `Icons` `Icon2` `$EXEDIR\icon2.ico`

FunctionEnd

# Custom page functions
# [[

Function ListViewShow

 EmbeddedLists::Dialog `$PLUGINSDIR\ListView_CheckBoxes.ini`
  Pop $R0

FunctionEnd

Function ListViewLeave

 StrCpy $R1 ``        ; Clear checked items list.

 Pop $R0              ; Checked item number.
 StrCmp $R0 /END +4   ; No item checked?
  ReadINIStr $R0 `$PLUGINSDIR\ListView_CheckBoxes.ini` `Item $R0` `Text`
  StrCpy $R1 $R1|$R0
 Goto -4              ; Loop.

 StrCpy $R1 $R1 `` 1  ; Trim first | from front.
 StrCmp $R1 `` +2     ; Skip MessageBox.
 MessageBox MB_OK `Checked items:$\r$\n$R1`

FunctionEnd

# ]]

# Empty section
Section
SectionEnd