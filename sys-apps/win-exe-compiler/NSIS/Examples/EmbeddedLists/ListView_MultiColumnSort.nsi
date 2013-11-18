!include MUI2.nsh

# EmbeddedLists example: ListView_MultiColumnSort.nsi
# Uses ListView_MultiColumnSort.ini
# Displays a list of items with multiple columns.
# Multiple items can be selected.
# Items can be sorted by clicking column headers.

# Settings
Name `EmbeddedLists Plugin Example`
OutFile `ListView_MultiColumnSort.exe`

# Pages
!insertmacro MUI_PAGE_WELCOME
Page Custom ListViewShow ListViewLeave

# Languages
!insertmacro MUI_LANGUAGE `English`

# Reserve plugin files (good practice)
ReserveFile `ListView_MultiColumnSort.ini`
ReserveFile `${NSISDIR}\Plugins\InstallOptions.dll`
ReserveFile `${NSISDIR}\Plugins\EmbeddedLists.dll`

# Callback functions
Function .onInit

 InitPluginsDir
 File `/oname=$PLUGINSDIR\ListView_MultiColumnSort.ini` `ListView_MultiColumnSort.ini`

 WriteINIStr `$PLUGINSDIR\ListView_MultiColumnSort.ini` `Icons` `Icon1` `$EXEDIR\icon1.ico`
 WriteINIStr `$PLUGINSDIR\ListView_MultiColumnSort.ini` `Icons` `Icon2` `$EXEDIR\icon2.ico`

FunctionEnd

# Custom page functions
# [[

Function ListViewShow

 EmbeddedLists::Dialog `$PLUGINSDIR\ListView_MultiColumnSort.ini`
  Pop $R0

FunctionEnd

Function ListViewLeave

 StrCpy $R1 ``        ; Clear selected items list.

 Pop $R0              ; Selected item number.
 StrCmp $R0 /END +4   ; No item selected?
  ReadINIStr $R0 `$PLUGINSDIR\ListView_MultiColumnSort.ini` `Item $R0` `Text`
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