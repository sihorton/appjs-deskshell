CRCCheck off
!addplugindir "..\Plugins" ;Just to make sure the plugin can befound by "makensis"

Name "MoreInfo NSIS test"

; This adds fields in the Version Tab of the File Properties.
VIProductVersion "1.0.2.900"
;
VIAddVersionKey Comments "Finally solved my own problems"
VIAddVersionKey SpecialBuild "My Special test build"
VIAddVersionKey PrivateBuild "A very private build"
VIAddVersionKey ProductName "Universal test is the name"
VIAddVersionKey ProductVersion "1.2"
VIAddVersionKey CompanyName "TheBogus Company"
VIAddVersionKey LegalCopyright "© 2005 TheBogus Company"
VIAddVersionKey FileVersion "1.2.8.2600"
VIAddVersionKey InternalName "Testing helper application"
VIAddVersionKey LegalTrademarks "All Rights Reserved."
VIAddVersionKey OriginalFilename "InfoTest.exe"
VIAddVersionKey FileDescription "Application for testing the NSIS plugin"
VIAddVersionKey MySelfDefinedField "123-55433-7654"

!define THISAPP "..\Release\MoreInfoTest.exe"
Var "Filename"
Var "FileInfoText"

OutFile ${THISAPP}

;--------------------------------
;Include Modern UI

  !include "MUI.nsh"

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" # first language is the default language
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"

;--------------------------------

Section

  ; Enter a filename you want to obtain the peoperties for.
  StrCpy $Filename ".\${THISAPP}"
  StrCpy $FileInfoText ""

  IfFileExists "$Filename" 0 lbl_done
  ClearErrors

  MoreInfo::GetComments "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText Comments: $1$\n"

  MoreInfo::GetSpecialBuild "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText SpecialBuild: $1$\n"

  MoreInfo::GetPrivateBuild "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText PrivateBuild: $1$\n"

  MoreInfo::GetProductName "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText ProductName: $1$\n"

  MoreInfo::GetProductVersion "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText ProductVersion: $1$\n"
  
  MoreInfo::GetCompanyName "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText CompanyName: $1$\n"
  
  MoreInfo::GetLegalCopyright "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText LegalCopyright: $1$\n"
  
  MoreInfo::GetFileVersion "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText FileVersion: $1$\n"

  MoreInfo::GetInternalName "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText InternalName: $1$\n"
  
  MoreInfo::GetLegalTrademarks "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText LegalTrademarks: $1$\n"

  MoreInfo::GetOriginalFilename "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText OriginalFilename: $1$\n"

  MoreInfo::GetFileDescription "$Filename"
  Pop $1
  StrCpy $FileInfoText "$FileInfoText FileDescription: $1$\n"
  
  MoreInfo::GetUserDefined "$Filename" "MySelfDefinedField"
	Pop $1
	StrCpy $FileInfoText "$FileInfoText$\nUser Defined: $1$\n$\n"

  ;**** Special Extention, very handy, we do not need to ask the language to the customer****
	StrCpy $FileInfoText "$FileInfoText OS User interface Language ID: $LANGUAGE $\n"

  MessageBox mb_ok "$FileInfoText" /SD IDOK
  lbl_done:
  
SectionEnd

Function .onInit

  MoreInfo::GetOSUserinterfaceLanguage
  ;pop $LANGUAGE  ; DO NOT POP, GetOSUserinterfaceLanguage returns value in $LANGUAGE, does not push any value

FunctionEnd
