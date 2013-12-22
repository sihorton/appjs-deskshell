*****************************************************************
*              NewTextReplace NSIS plugin v0.4                  *
*                  by Gringoloco023, 2010                       *
*            http://portableapps.com/node/21840                 *
*                          Based on:                            *
*                TextReplace NSIS plugin v1.5                   *
*                                                               *
* 2006 Shengalts Aleksander aka Instructor (Shengalts@mail.ru)  *
*****************************************************************

Features:
- support added for utf-8 & utf-16LE files
- Fast search/replacement in text file
- Case sensitive/insensitive replacement (only for latin characters!!!)
- Supports strings and pointers to the buffer
- If no changes possible, output file will be untouched


**** Search in file ****

${textreplace::FindInFile} "[InputFile]" "[FindIt]" "[Options]" $var

"[InputFile]"   - Input file

"[FindIt]"      - String to find or pointer to the buffer if used option /PI=1

"[Options]"     - Search options

	/U=[0|1]
		/U=0   - UTF-8/ANSI (default)
		/U=1   - UTF-16LE
	/S=[0|1]
		/S=0   - Case insensitive (default) (only for latin characters!!!)
		/S=1   - Case sensitive (faster)
	/PI=[0|1]
		/PI=0  - FindIt is a string (default)
		/PI=1  - FindIt is a pointer to the text buffer

$var   number of founded strings
       -3   ReplaceIt string is empty
       -4   can't open input file for reading
       -5   can't get file size of the input file
       -6   can't allocate buffer for input file text
       -7   can't read input file


**** Replace in file ****

${textreplace::ReplaceInFile} "[InputFile]" "[OuputFile]" "[ReplaceIt]" "[ReplaceWith]" "[Options]" $var

"[InputFile]"   - Input file

"[OutputFile]"  - Output file, can be equal to InputFile

"[ReplaceIt]"   - String to replace or pointer to the buffer if used option /PI=1

"[ReplaceWith]" - Replace with this string or pointer to the buffer if used option /PO=1

"[Options]"     - Replace options

	/U=[0|1]
		/U=0   - UTF-8/ANSI (default)
		/U=1   - UTF-16LE
	/S=[0|1]
		/S=0   - Case insensitive (default) (only for latin characters!!!)
		/S=1   - Case sensitive (faster)
	/C=[1|0]
		/C=1   - Copy the file if no changes made (default)
		/C=0   - Don't copy the file if no changes made
	/AI=[1|0]
		/AI=1  - Copy attributes from the InputFile to OutputFile (default)
		/AI=0  - Don't copy attributes
	/AO=[0|1]
		/AO=0  - Don't change OutputFile attributes (error "-9" possible) (default)
		/AO=1  - Change OutputFile attributes to normal before writting
	/PI=[0|1]
		/PI=0  - ReplaceIt is a string (default)
		/PI=1  - ReplaceIt is a pointer to the text buffer
	/PO=[0|1]
		/PO=0  - ReplaceWith is a string (default)
		/PO=1  - ReplaceWith is a pointer to the text buffer

$var   number of replacements
       -1   ReplaceIt pointer is incorrect
       -2   ReplaceWith pointer is incorrect
       -3   ReplaceIt string is empty
       -4   can't open input file for reading
       -5   can't get file size of the input file
       -6   can't allocate buffer for input file text
       -7   can't read input file
       -9   can't open output file for writting
       -10  can't allocate buffer for output file text
       -11  can't write to the output file


**** Put text file contents to the buffer ****

${textreplace::FillReadBuffer} "[File]" $var

"[File]"   - Input file

$var   pointer to the buffer
       -4   can't open input file for reading
       -5   can't get file size of the input file
       -6   can't allocate buffer for input file text
       -7   can't read input file


**** Free buffer ****

${textreplace::FreeReadBuffer} "[Pointer]"

"[Pointer]"  - Pointer to the buffer


**** Unload plugin ****

${textreplace::Unload}
