!include MUI.nsh
!include WinMessages.nsh

## Basic stuff here
Name `RealProgress Example`
OutFile `RealProgress FileProgress.exe`

## Pages and languages
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE English

Section

  ## Add a large file here (say 30 MB).
  ## Moves the progress bar 30% while the file is uncompressed.
  RealProgress::FileProgress /NOUNLOAD 30
  File "C:\Downloaded Files\Games\Patches\Doom3\D3_1_3.exe"

  ## Add a large file here (say 10 MB).
  ## Moves the progress bar 10% while the file is uncompressed.
  RealProgress::FileProgress /NOUNLOAD 10
  File "C:\Downloaded Files\Apache HTTP Server\ActivePerl-5.8.4.810-MSWin32-x86.msi"

  ## Add a large file here (say 5 MB).
  ## Moves the progress bar 5% while the file is uncompressed.
  #RealProgress::FileProgress /NOUNLOAD 5
  File "C:\Downloaded Files\Apache HTTP Server\apache_2.0.50-win32-x86-no_ssl.msi"

  ## All adds up to 100%...
  # 5% + 25% + 25% + 30% + 10% + 5% = 100%

  ## Note: Even if it did go over 100%, there would be no problems.
  ## Raise it by another 5% even though it is already at 100%. No change occurs.
  RealProgress::AddProgress /NOUNLOAD 5

SectionEnd

## Unload the plugin so that it can be deleted!
Function .onGUIEnd
  RealProgress::Unload
FunctionEnd