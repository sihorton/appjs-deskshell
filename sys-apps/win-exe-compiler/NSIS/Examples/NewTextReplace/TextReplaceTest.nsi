Name "TextReplaceTest"
OutFile "TextReplaceTest.exe"

!include "TextReplace.nsh"
!include "Sections.nsh"

Var RADIOBUTTON

Page components
Page instfiles


Section "Basic" Basic
	${textreplace::FindInFile} "C:\input.txt" "abc" "/S=1" $0
	MessageBox MB_OK 'textreplace::FindInFile$\n$$0={$0}'

	${textreplace::ReplaceInFile} "C:\input.txt" "C:\output.txt" "abc" "xyz" "/S=1 /C=1 /AO=1" $0
	MessageBox MB_OK 'textreplace::ReplaceInFile$\n$$0={$0}'

	${textreplace::Unload}
SectionEnd

Section /o "FindIt as pointer" FindItPointer
	${textreplace::FillReadBuffer} "C:\FindIt.txt" $0
	MessageBox MB_OK 'textreplace::FillReadBuffer$\n$$0={$0}'

	${textreplace::FindInFile} "C:\input.txt" "$0" "/PI=1" $1
	MessageBox MB_OK 'textreplace::FindInFile$\n$$1={$1}'

	${textreplace::FreeReadBuffer} "$0"
	${textreplace::Unload}
SectionEnd

Section /o "ReplaceWith as pointer" ReplaceWithPointer
	${textreplace::FillReadBuffer} "C:\ReplaceWith.txt" $0
	MessageBox MB_OK 'textreplace::FillReadBuffer$\n$$0={$0}'

	${textreplace::ReplaceInFile} "C:\input.txt" "C:\output.txt" "abc" "$0" "/PO=1" $1
	MessageBox MB_OK 'textreplace::ReplaceInFile$\n$$1={$1}'

	${textreplace::FreeReadBuffer} "$0"
	${textreplace::Unload}
SectionEnd

Section /o "ReplaceIt and ReplaceWith as pointers" ReplaceItReplaceWithPointers
	${textreplace::FillReadBuffer} "C:\ReplaceIt.txt" $0
	MessageBox MB_OK 'textreplace::FillReadBuffer$\n$$0={$0}'

	${textreplace::FillReadBuffer} "C:\ReplaceWith.txt" $1
	MessageBox MB_OK 'textreplace::FillReadBuffer$\n$$1={$1}'

	${textreplace::ReplaceInFile} "C:\input.txt" "C:\output.txt" "$0" "$1" "/S=1 /C=1 /PI=1 /PO=1" $2
	MessageBox MB_OK 'textreplace::ReplaceInFile$\n$$2={$2}'

	${textreplace::FreeReadBuffer} "$0"
	${textreplace::FreeReadBuffer} "$1"
	${textreplace::Unload}
SectionEnd


Function .onInit
	StrCpy $RADIOBUTTON ${Basic}
FunctionEnd

Function .onSelChange
	!insertmacro StartRadioButtons $RADIOBUTTON
	!insertmacro RadioButton ${Basic}
	!insertmacro RadioButton ${FindItPointer}
	!insertmacro RadioButton ${ReplaceWithPointer}
	!insertmacro RadioButton ${ReplaceItReplaceWithPointers}
	!insertmacro EndRadioButtons
FunctionEnd
