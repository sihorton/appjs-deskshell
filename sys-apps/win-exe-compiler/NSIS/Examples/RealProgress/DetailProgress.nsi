!include MUI.nsh
!include WinMessages.nsh

## Basic stuff here
Name `RealProgress Example`
OutFile `RealProgress DetailProgress.exe`

## Pages and languages
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE English

Section

  ## This will move the progress bar by 70%
  ## over a period while adding 10 items to the
  ## log window.
  RealProgress::DetailProgress /NOUNLOAD 10 70

  ## We use DetailPrint to add items to the
  ## log window. It could however be items
  ## being added from a File /r instruction.
  ## You just need to set the number from 10 to
  ## the number of files + number of folders.
  DetailPrint 1
  Sleep 100
  DetailPrint 2
  Sleep 100
  DetailPrint 3
  Sleep 100
  DetailPrint 4
  Sleep 100
  DetailPrint 5
  Sleep 100
  DetailPrint 6
  Sleep 100
  DetailPrint 7
  Sleep 100
  DetailPrint 8
  Sleep 100
  DetailPrint 9
  Sleep 100
  DetailPrint 10

SectionEnd

## Unload the plugin so that it can be deleted!
Function .onGUIEnd
  RealProgress::Unload
FunctionEnd