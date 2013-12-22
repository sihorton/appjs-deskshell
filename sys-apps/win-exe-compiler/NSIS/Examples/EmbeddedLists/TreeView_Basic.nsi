!include MUI2.nsh

# EmbeddedLists example: TreeView_Basic.nsi
# Uses TreeView_Basic.ini

# Settings
Name `EmbeddedLists Plugin Example`
OutFile `TreeView_Basic.exe`

# Pages
!insertmacro MUI_PAGE_WELCOME
Page Custom ListViewShow ListViewLeave
!insertmacro MUI_PAGE_DIRECTORY

# Languages
!insertmacro MUI_LANGUAGE `English`

# Reserve plugin files (good practice)
ReserveFile `TreeView_Basic.ini`
ReserveFile `${NSISDIR}\Plugins\InstallOptions.dll`
ReserveFile `${NSISDIR}\Plugins\EmbeddedLists.dll`

# Callback functions
Function .onInit

 InitPluginsDir
 File `/oname=$PLUGINSDIR\TreeView_Basic.ini` `TreeView_Basic.ini`

 WriteINIStr `$PLUGINSDIR\TreeView_Basic.ini` `Icons` `Icon1` `$EXEDIR\icon1.ico`
 WriteINIStr `$PLUGINSDIR\TreeView_Basic.ini` `Icons` `Icon2` `$EXEDIR\icon2.ico`

FunctionEnd

# Custom page functions
# [[

Function ListViewShow

 EmbeddedLists::Dialog `$PLUGINSDIR\TreeView_Basic.ini`
  Pop $R0

FunctionEnd

Function ListViewLeave

 StrCpy $R1 ``        ; Clear selected items list.

 Pop $R0              ; Selected item number.
 StrCmp $R0 /END +4   ; No item selected?
  ReadINIStr $R0 `$PLUGINSDIR\TreeView_Basic.ini` `Item $R0` `Text`
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