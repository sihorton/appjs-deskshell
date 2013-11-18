Name "Font Functions"
OutFile "FontFunc.exe"
XPStyle on
RequestExecutionLevel user

!include "WordFunc.nsh"

var TestFont
var FontVersion
var FontName
var LocalFontName
var LocalFontVersion

Page components
Page instfiles

Section
   StrCpy $TestFont "arial.ttf"

   ; We are going to test to make sure that we get the same values
   IfFileExists $FONTS\$TestFont 0 "FontNotFound"
      GetFontVersionLocal "C:\Windows\Fonts\arial.ttf" $LocalFontVersion
      GetFontNameLocal "C:\Windows\Fonts\arial.ttf" $LocalFontName
      DetailPrint "Build Machine: $LocalFontName is version $LocalFontVersion."

      GetFontVersion $FONTS\$TestFont $FontVersion
      GetFontName $FONTS\$TestFont $FontName
      DetailPrint "Install Machine: $FontName is version $FontVersion."

      ${VersionCompare} $LocalFontVersion $FontVersion $0

      IntCmp $0 0 0 "FontDiff" "FontDiff"
         MessageBox MB_OK "Font versions are the same! Font Version = $FontVersion."
         goto FontEnd
      FontDiff:
         MessageBox MB_OK|MB_ICONEXCLAMATION "Font Version Error: $LocalFontVersion != $FontVersion"
      FontEnd:
      

      StrCmpS $LocalFontName $FontName 0 "FontNameDiff"
         MessageBox MB_OK "Font names are the same! Font Name = $FontName."
         goto FontNameEnd
      FontNameDiff:
         MessageBox MB_OK|MB_ICONEXCLAMATION "Font Name Error: $LocalFontName != $FontName."
      FontNameEnd:

      goto "EndInstall"

   FontNotFound:
      MessageBox MB_OK|MB_ICONEXCLAMATION "Could not find font $TestFont in $FONTS!"

   EndInstall:
      MessageBox MB_OK "Done!"
SectionEnd

!verbose 3
