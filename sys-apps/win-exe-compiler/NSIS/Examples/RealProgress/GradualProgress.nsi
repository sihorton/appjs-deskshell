!include MUI.nsh
!include WinMessages.nsh

## Basic stuff here
Name `RealProgress Example`
OutFile `RealProgress GradualProgress.exe`

## Pages and languages
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE English

Section

  ## Start progress bar on 5%.
  #RealProgress::AddProgress /NOUNLOAD 5
  SetOutPath $EXEDIR

  ## Increase by 5% per second until "Finished large process!" is added to the list (with DetailPrint),
  ## increasing the progress bar by a total of 25%!
  DetailPrint "Going to Sleep for 7 seconds sorry..."
  ## The progress bar will increase by 5% each second for the first 5 of the 7 seconds.
  RealProgress::GradualProgress /NOUNLOAD 1 5 25 "Finished large process!"
  Sleep 7000 ## 7 seconds.
  DetailPrint "Finished large process!"

  ## Increase by 5% per second until something new is added to the list,
  ## increasing the progress bar by a total of 25%!
  DetailPrint "Going to Sleep for 3 more seconds sorry..."
  RealProgress::GradualProgress /NOUNLOAD 1 5 25
  Sleep 3000 ## 3 seconds.
  DetailPrint "Finished another large process!"

SectionEnd

## Unload the plugin so that it can be deleted!
Function .onGUIEnd
  RealProgress::Unload
FunctionEnd