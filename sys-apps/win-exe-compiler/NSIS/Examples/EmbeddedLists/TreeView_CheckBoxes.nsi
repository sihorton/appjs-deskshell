!include MUI2.nsh

# EmbeddedLists example: TreeView_CheckBoxes.nsi
# Uses TreeView_CheckBoxes.ini

# Settings
Name `EmbeddedLists Plugin Example`
OutFile `TreeView_CheckBoxes.exe`

# Pages
!insertmacro MUI_PAGE_WELCOME
Page Custom ListViewShow ListViewLeave
!insertmacro MUI_PAGE_COMPONENTS

# Languages
!insertmacro MUI_LANGUAGE `English`

# Reserve plugin files (good practice)
ReserveFile `TreeView_CheckBoxes.ini`
ReserveFile `${NSISDIR}\Plugins\InstallOptions.dll`
ReserveFile `${NSISDIR}\Plugins\EmbeddedLists.dll`

# Callback functions
Function .onInit

 InitPluginsDir
 File `/oname=$PLUGINSDIR\TreeView_CheckBoxes.ini` `TreeView_CheckBoxes.ini`

 WriteINIStr `$PLUGINSDIR\TreeView_CheckBoxes.ini` `Icons` `Icon1` `$EXEDIR\icon1.ico`
 WriteINIStr `$PLUGINSDIR\TreeView_CheckBoxes.ini` `Icons` `Icon2` `$EXEDIR\icon2.ico`

FunctionEnd

# Custom page functions
# [[

Function ListViewShow

 EmbeddedLists::Dialog `$PLUGINSDIR\TreeView_CheckBoxes.ini`
  Pop $R0

FunctionEnd

Function ListViewLeave

 StrCpy $R1 ``        ; Clear checked items list.

 Pop $R0              ; Checked item number.
 StrCmp $R0 /END +4   ; No item checked?
  ReadINIStr $R0 `$PLUGINSDIR\TreeView_CheckBoxes.ini` `Item $R0` `Text`
  StrCpy $R1 $R1|$R0
 Goto -4              ; Loop.

 StrCpy $R1 $R1 `` 1  ; Trim first | from front.
 StrCmp $R1 `` +2     ; Skip MessageBox.
 MessageBox MB_OK `Selected items:$\r$\n$R1`

FunctionEnd

# ]]

# Empty section
Section a
SectionEnd