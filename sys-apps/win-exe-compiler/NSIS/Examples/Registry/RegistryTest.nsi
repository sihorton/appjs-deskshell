Name "RegistryTest"
OutFile "RegistryTest.exe"

!include "Registry.nsh"
!include "Sections.nsh"

Var RADIOBUTTON

Page components
Page instfiles


Section "Basic registry functions" Basic
	${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" $R0
	MessageBox MB_OK "registry::KeyExists$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::Write} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "%WINDIR%\notepad.exe" "REG_EXPAND_SZ" $R0
	MessageBox MB_OK "registry::Write$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0 $R1
	MessageBox MB_OK 'registry::Read$\n$\n\
			$$R0    "string" =[$R0] = %WinDir%\notePad.exe$\n\
			$$R1    "type"   =[$R1] = REG_EXPAND_SZ$\n'

	${registry::CreateKey} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\new1\new2\new3" $R0
	MessageBox MB_OK "registry::CreateKey$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::CreateKey} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\new1\new2\new3" $R0
	MessageBox MB_OK "registry::CreateKey$\n$\n\
			Errorlevel: [$R0] = 1"

	${registry::DeleteKeyEmpty} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\new1\new2" $R0
	MessageBox MB_OK "registry::DeleteEmptyKey$\n$\n\
			Errorlevel: [$R0] = -1"

	${registry::DeleteKeyEmpty} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\new1\new2\new3" $R0
	MessageBox MB_OK "registry::DeleteEmptyKey$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\new1" $R0
	MessageBox MB_OK "registry::DeleteKey$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::DeleteValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0
	MessageBox MB_OK "registry::DeleteValue$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::CopyValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "MakeNSISWPlacement" "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\Symbols" "copied_MakeNSISWPlacement" $R0
	MessageBox MB_OK "registry::CopyValue$\n$\n\
			Errorlevel: [$R0] = -1"

	${registry::MoveValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS\Symbols" "copied_MakeNSISWPlacement" "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "moved_MakeNSISWPlacement" $R0
	MessageBox MB_OK "registry::MoveValue$\n$\n\
			Errorlevel: [$R0] = -1"

	${registry::DeleteValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "moved_MakeNSISWPlacement" $R0

	${registry::CopyKey} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "HKEY_CURRENT_USER\SOFTWARE\_NSIS" $R0
	MessageBox MB_OK "registry::CopyKey$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::MoveKey} "HKEY_CURRENT_USER\SOFTWARE\_NSIS" "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS_" $R0
	MessageBox MB_OK "registry::MoveKey$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS_" $R0

	${registry::StrToHex} "Some Value" $0

	${registry::Write} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "$0" "REG_BINARY" $R0
	MessageBox MB_OK "registry::StrToHex$\n$\n\
			Hex string: [$0]$\n$\n = 536f6d652056616c7565"

	${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0 $R1

	${registry::HexToStr} "$R0" $R1
	MessageBox MB_OK "registry::HexToStr$\n$\n\
			String: [$R1] = Some Value"
!ifdef NSIS_UNICODE
	${registry::StrToHexUTF16LE} "Some Value" $0

	${registry::Write} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "$0" "REG_BINARY" $R0
	MessageBox MB_OK "registry::StrToHexUTF16LE$\n$\n\
			Hex string: [$0]$\n$\n = 53006f006d0065002000560061006c0075006500"

	${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0 $R1

	${registry::HexToStrUTF16LE} "$R0" $R1
	MessageBox MB_OK "registry::HexToStrUTF16LE$\n$\n\
			String: [$R1] = Some Value"
!endif
	${registry::DeleteValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0


	#Write extra string
	StrCpy $0 0
	StrCpy $1 0
	IntOp $0 $0 + 1
	StrCpy $1 '$1.$0'
	StrLen $2 $1
	IntCmp $2 1022 0 -3

	${registry::Write} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "$1" "REG_SZ" $R0
	MessageBox MB_OK "registry::Write$\n$\n\
			Errorlevel: [$R0] = 0"

	${registry::WriteExtra} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "----More text----" $R0
	MessageBox MB_OK "registry::WriteExtra$\n$\n\
			Errorlevel: [$R0] = 0"


	#Read extra string
	StrCpy $0 0

	loop:
	${registry::ReadExtra} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" "$0" $R0 $R1
	IntOp $0 $0 + 1022   #if binary data then +511

	MessageBox MB_YESNO 'Read next part?$\n$\n\
			registry::ReadExtra$\n$\n\
			$$R0    "string" =[$R0] = 1 -> 282 / ----More text----$\n\
			$$R1    "type"   =[$R1] = REG_SZ' IDYES loop

	${registry::DeleteValue} "HKEY_LOCAL_MACHINE\SOFTWARE\NSIS" "new" $R0

	${registry::Unload}
SectionEnd


Section /o "Search for value 'Content Type'" SearchValue
	${registry::Open} "HKEY_LOCAL_MACHINE" "/K=0 /V=1 /S=0 /B=1 /N='Content Type'" $0
	StrCmp $0 0 0 loop
	MessageBox MB_OK "Error" IDOK close

	loop:
	${registry::Find} "$0" $1 $2 $3 $4

	MessageBox MB_OKCANCEL '$$1    "path"   =[$1]$\n\
				$$2    "value" =[$2]$\n\
				$$3    "string" =[$3]$\n\
				$$4    "type"   =[$4]$\n\
								$\n\
				Find next?' IDOK loop
	close:
	${registry::Close} "$0"
	${registry::Unload}
SectionEnd


Section /o "Search and write founded in text file" SearchAndWriteInFile
	GetTempFileName $R0
	FileOpen $R1 $R0 w
	FileWrite $R1 'HKEY_CURRENT_CONFIG$\r$\n$\r$\n'

	${registry::Open} "HKEY_CURRENT_CONFIG" "/B=1" $0
	StrCmp $0 0 0 loop
	MessageBox MB_OK "Error" IDOK close

	loop:
	${registry::Find} "$0" $1 $2 $3 $4

	StrCmp $4 '' close
	StrCmp $4 'REG_KEY' 0 +3
	FileWrite $R1 '$4:"$1\$2"$\r$\n'
	goto +2
	FileWrite $R1 '$4:"$1" "$2"="$3"$\r$\n'
	goto loop

	close:
	${registry::Close} "$0"
	${registry::Unload}
	FileClose $R1

	Exec '"notepad.exe" "$R0"'
SectionEnd


### If nsx.dll not found then "Search with banner" example will not be compile ###
!system 'ECHO.>"%TEMP%\Temp$$$.nsh"'
!system 'IF EXIST "${NSISDIR}\Plugins\nxs.dll" ECHO !define nxs_exist>>"%TEMP%\Temp$$$.nsh"'
!include "$%TEMP%\Temp$$$.nsh"
!system 'DEL "%TEMP%\Temp$$$.nsh"'

!ifdef nxs_exist
Section /o "Search with banner - 'NxS' plugin required" SearchWithBanner
	HideWindow

	nxs::Show /NOUNLOAD `$(^Name) Setup`\
		/top `Setup searching something$\nPlease wait... If you can...`\
		/pos 78 /h 0 /can 1 /end

	${registry::Open} "HKLM\System" '/K=0 /V=1 /S=0 /N="Unexisted Name" /T=REG_DWORD /B=2' $0
	StrCmp $0 0 0 loop
	MessageBox MB_OK "Error" IDOK close

	loop:
	${registry::Find} "$0" $1 $2 $3 $4

	StrCmp $4 '' close
	StrCmp $4 'BANNER' 0 code
	nxs::Update /NOUNLOAD /sub "$1" /end
	nxs::HasUserAborted /NOUNLOAD
	Pop $5
	StrCmp $5 1 close loop

	code:
	;... code
	goto loop

	close:
	${registry::Close} "$0"
	${registry::Unload}
	nxs::Destroy

	BringToFront
SectionEnd
!endif


Section /o "Save to the file" SaveKey
	${registry::SaveKey} "HKCU\SOFTWARE\NSIS" "$EXEDIR\saved.reg" "/G=1 /D=2" $R0
	${registry::Unload}
	MessageBox MB_OK "registry::SaveKey$\n$\n\
			Errorlevel: [$R0] = 0"
SectionEnd


Section /o "Restore from the file" RestoreKey
	${registry::RestoreKey} "$EXEDIR\saved.reg" $R0
	${registry::Unload}
	MessageBox MB_OK "registry::RestoreKey$\n$\n\
			Errorlevel: [$R0] = 0"
SectionEnd


Function .onInit
	StrCpy $RADIOBUTTON ${Basic}
FunctionEnd

Function .onSelChange
	!insertmacro StartRadioButtons $RADIOBUTTON
	!insertmacro RadioButton ${Basic}
	!insertmacro RadioButton ${SearchValue}
	!insertmacro RadioButton ${SearchAndWriteInFile}
	!ifdef nxs_exist
		!insertmacro RadioButton ${SearchWithBanner}
	!endif
	!insertmacro RadioButton ${SaveKey}
	!insertmacro RadioButton ${RestoreKey}
	!insertmacro EndRadioButtons
FunctionEnd
