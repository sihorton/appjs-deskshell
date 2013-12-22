!include MUI2.nsh

# EmbeddedLists example: ListView_LabelEdit.nsi
# Uses ListView_LabelEdit.ini
# Displays a list view dialog containing a few items.
# Only one item can be selected.
# Items are sorted alphabetically in ascending order.

# Settings
Name `EmbeddedLists Plugin Example`
OutFile `ListView_LabelEdit.exe`

# Pages
!insertmacro MUI_PAGE_WELCOME
Page Custom ListViewShow ListViewLeave
!insertmacro MUI_PAGE_DIRECTORY

# Languages
!insertmacro MUI_LANGUAGE `English`

# Reserve plugin files (good practice)
ReserveFile `ListView_LabelEdit.ini`
ReserveFile `${NSISDIR}\Plugins\InstallOptions.dll`
ReserveFile `${NSISDIR}\Plugins\EmbeddedLists.dll`

# Callback functions
Function .onInit

 InitPluginsDir
 File `/oname=$PLUGINSDIR\ListView_LabelEdit.ini` `ListView_LabelEdit.ini`

FunctionEnd

# Custom page functions
# [[

Function ListViewShow

 EmbeddedLists::Dialog `$PLUGINSDIR\ListView_LabelEdit.ini`
  Pop $R0

FunctionEnd

Function ListViewLeave

 StrCpy $R1 ``        ; Clear selected items list.

 Pop $R0              ; Selected item number.
 StrCmp $R0 /END +4   ; No item selected?
  ReadINIStr $R0 `$PLUGINSDIR\ListView_LabelEdit.ini` `Item $R0` `Text`
  StrCpy $R1 $R1|$R0
 Goto -4              ; Loop.

 StrCpy $R1 $R1 `` 1  ; Trim first | from front.
 StrCmp $R1 `` +2     ; Skip MessageBox.
 MessageBox MB_OK `Selected items:$\r$\n$R1`

FunctionEnd

# ]]

# Empty section
Section
SectionEnd