*****************************************************************
***                Registry NSIS plugin v3.5                  ***
*****************************************************************

2008 Shengalts Aleksander aka Instructor (Shengalts@mail.ru)

Unicode support (beta) added by gringoloco023 -- 01/31/2010, http://portableapps.com/node/21879
New code for RestoreKey by gringoloco023 -- 05/24/2010


Features:
- Powerful registry search:
   -fast algorithm
   -principle of turn in stack (first in -> last out)
     i.e. search from first registry key to last
   -search for key, value and/or string in any root
   -search with name and/or type
   -search with banner support
   -search with subkeys or not
- Check is registry key exists
- Read value of any type and size
- Write value of any type and size
- Create key
- Delete value     (same as DeleteRegValue)
- Delete key       (same as DeleteRegKey)
- Delete empty key (if no values and subkeys in it)
- Copy value
- Move value
- Copy key
- Move key
- Export key contents to the file in format
- Import key contents from the file to the registry
- Converts string to hex values
- Converts hex values to string


**** Open for search ****

${registry::Open} "[fullpath]" "[Options]" $var

"[fullpath]"  - Registry path (Root\SubKey)

	Root:
	HKEY_CLASSES_ROOT      HKCR
	HKEY_CURRENT_USER      HKCU
	HKEY_LOCAL_MACHINE     HKLM
	HKEY_USERS             HKU
	HKEY_PERFORMANCE_DATA  HKPD
	HKEY_CURRENT_CONFIG    HKCC
	HKEY_DYN_DATA          HKDD

"[Options]"   - "/K=[1|0] /V=[1|0] /S=[1|0] /N=[name] /T=[TYPE] /G=[1|0] /B=[0|1|2]"

	/K=[1|0]
		/K=1  - Search Keys (default)
		/K=0  - Don't search Keys
	/V=[1|0]
		/V=1  - Search Values (default)
		/V=0  - Don't search Values
	/S=[1|0]
		/S=1  - Search Strings (default)
		/S=0  - Don't search Values
	/N=[name]
		             - Search for all (default)
		/N=          - Search for empty
		/N=version   - Search for exact name: "version"
		               can be in quotes "[name]", '[name]', `[name]`
	/NS=[name]
		/NS=version  - Sensitive search for a part of name: "version" (e.g. "myversion")
		               can be in quotes "[name]", '[name]', `[name]`
	/NI=[name]
		/NI=version  - Insensitive search for a part of name: "version" (e.g. "MyVersion")
		               can be in quotes "[name]", '[name]', `[name]`
	/T=[TYPE]
		                                    - Search for all types (default)
		/T=REG_BINARY                       - Search for REG_BINARY
		/T=REG_DWORD                        - Search for REG_DWORD
		/T=REG_DWORD_BIG_ENDIAN             - Search for REG_DWORD_BIG_ENDIAN
		/T=REG_EXPAND_SZ                    - Search for REG_EXPAND_SZ
		/T=REG_MULTI_SZ                     - Search for REG_MULTI_SZ
		/T=REG_NONE                         - Search for REG_NONE
		/T=REG_SZ                           - Search for REG_SZ
		/T=REG_LINK                         - Search for REG_LINK
		/T=REG_RESOURCE_LIST                - Search for REG_RESOURCE_LIST
		/T=REG_FULL_RESOURCE_DESCRIPTOR     - Search for REG_FULL_RESOURCE_DESCRIPTOR
		/T=REG_RESOURCE_REQUIREMENTS_LIST   - Search for REG_RESOURCE_REQUIREMENTS_LIST
		/T=REG_QWORD                        - Search for REG_QWORD
	/G=[1|0]
		/G=1  - Search with subkeys (default)
		/G=0  - Don't search subkeys
	/B=[0|1|2]
		/B=0  - Banner isn't used (default)
		/B=1  - Banner isn't used, but show
		        in the details current searching path
		/B=2  - Banner is used. Return: "path", "", "", "", "BANNER"
		        when starts to search in new key

$var     Handle, zero if error


**** Find first and next (call one or more times) ****

${registry::Find} "[handle]" $var1 $var2 $var3 $var4

"[handle]"   handle returned by registry::Open

$var1        "[path]"
$var2        "[value]" or "[key]"
$var3        "[string]"
$var4        "[TYPE]"
	TYPE:
	""                                -Search is finished
	"BANNER"                          -Banner is used, return only path
	"REG_KEY"                         -Registry key is found
	"REG_BINARY"                      -Raw binary data
	"REG_DWORD"                       -Double word in machine format (low-endian on Intel)
	"REG_DWORD_BIG_ENDIAN"            -Double word in big-endian format
	"REG_EXPAND_SZ"                   -String with unexpanded environment variables
	"REG_MULTI_SZ"                    -Multiple strings, next string separated by new line '$\n'
	"REG_NONE"                        -Undefined type
	"REG_SZ"                          -Null-terminated string
	"REG_LINK"                        -Unicode symbolic link
	"REG_RESOURCE_LIST"               -Device-driver resource list
	"REG_FULL_RESOURCE_DESCRIPTOR"    -Resource list in the hardware description
	"REG_RESOURCE_REQUIREMENTS_LIST"  -
	"REG_QWORD"                       -64-bit number
	"INVALID"                         -Invalid type code


**** Close search (free memory) ****

${registry::Close} "[handle]"

"[handle]"   handle returned by registry::Open


**** KeyExists (check is registry key exists) ****

${registry::KeyExists} "[fullpath]" $var

$var     0 - key exists
        -1 - key doesn't exist


**** Registry Read ****

${registry::Read} "[fullpath]" "[value]" $var1 $var2

$var1    "[string]"
$var2    "[TYPE]"
	TYPE:
	""                                -Value does not exist
	"REG_BINARY"                      -Raw binary data
	"REG_DWORD"                       -Double word in machine format (low-endian on Intel)
	"REG_DWORD_BIG_ENDIAN"            -Double word in big-endian format
	"REG_EXPAND_SZ"                   -String with unexpanded environment variables
	"REG_MULTI_SZ"                    -Multiple strings, next string separated by new line '$\n'
	"REG_NONE"                        -Undefined type
	"REG_SZ"                          -Null-terminated string
	"REG_LINK"                        -Unicode symbolic link
	"REG_RESOURCE_LIST"               -Device-driver resource list
	"REG_FULL_RESOURCE_DESCRIPTOR"    -Resource list in the hardware description
	"REG_RESOURCE_REQUIREMENTS_LIST"  -
	"REG_QWORD"                       -64-bit number
	"INVALID"                         -Invalid type code


**** Registry Write ****

${registry::Write} "[fullpath]" "[value]" "[string]" "[TYPE]" $var

"[TYPE]"  - Type of string to write
	REG_SZ                         (e.g. String #1)              same as WriteRegStr
	REG_EXPAND_SZ                  (e.g. %WINDIR%\notepad.exe)   same as WriteRegExpandStr
	REG_MULTI_SZ                   (e.g. First$\nSecond$\nThird)
	REG_DWORD                      (e.g. 1234567890)             same as WriteRegDWORD
	REG_DWORD_BIG_ENDIAN           (e.g. 1234567890)
	REG_BINARY                     (e.g. 591B0000451F)           same as WriteRegBin
	REG_NONE                       (e.g. 591B0000451F)
	REG_LINK                       (e.g. 591B0000451F)
	REG_RESOURCE_LIST              (e.g. 591B0000451F)
	REG_FULL_RESOURCE_DESCRIPTOR   (e.g. 591B0000451F)
	REG_RESOURCE_REQUIREMENTS_LIST (e.g. 591B0000451F)
	REG_QWORD                      (e.g. 591B0000451F)

$var     0 - success
        -1 - error


**** Registry Extra Read ****

${registry::ReadExtra} "[fullpath]" "[value]" "[number]" $var1 $var2

"[number]"  Number of bytes to read from. If negative
            number of bytes from end.

$var1       "[string]"
$var2       "[TYPE]"
	TYPE:
	""                                -Value does not exist
	"REG_BINARY"                      -Raw binary data
	"REG_DWORD"                       -Double word in machine format (low-endian on Intel)
	"REG_DWORD_BIG_ENDIAN"            -Double word in big-endian format
	"REG_EXPAND_SZ"                   -String with unexpanded environment variables
	"REG_MULTI_SZ"                    -Multiple strings, next string separated by new line '$\n'
	"REG_NONE"                        -Undefined type
	"REG_SZ"                          -Null-terminated string
	"REG_LINK"                        -Unicode symbolic link
	"REG_RESOURCE_LIST"               -Device-driver resource list
	"REG_FULL_RESOURCE_DESCRIPTOR"    -Resource list in the hardware description
	"REG_RESOURCE_REQUIREMENTS_LIST"  -
	"REG_QWORD"                       -64-bit number
	"INVALID"                         -Invalid type code


**** Registry Extra Write ****

${registry::WriteExtra} "[fullpath]" "[value]" "[string]" $var

"[string]"  - Append this string to the existed one

$var     0 - success
        -1 - error


**** Create Registry Key ****

${registry::CreateKey} "[fullpath]" $var

"[fullpath]"  - Key to create (recursively if necessary)

$var     1 - [fullpath] already exists
         0 - [fullpath] successfully created
        -1 - error


**** Delete Registry Value (same as DeleteRegValue) ****

${registry::DeleteValue} "[fullpath]" "[value]" $var

$var     0 - success
        -1 - error


**** Delete Registry Key (same as DeleteRegKey) ****

${registry::DeleteKey} "[fullpath]" $var

$var     0 - success
        -1 - error


**** Delete Empty Registry Key (if no values and subkeys in it) ****

${registry::DeleteKeyEmpty} "[fullpath]" $var

$var     0 - success
        -1 - error


**** Copy Registry Value ****

${registry::CopyValue} "[fullpath_source]" "[value_source]" "[fullpath_target]" "[value_target]" $var

$var     0 - success
        -1 - error


**** Move Registry Value ****

${registry::MoveValue} "[fullpath_source]" "[value_source]" "[fullpath_target]" "[value_target]" $var

$var     0 - success
        -1 - error


**** Copy Registry Key ****

${registry::CopyKey} "[fullpath_source]" "[fullpath_target]\[new_key_name]" $var

$var     0 - success
        -1 - error


**** Move Registry Key ****

${registry::MoveKey} "[fullpath_source]" "[fullpath_target]\[new_key_name]" $var

$var     0 - success
        -1 - error


**** Registry Export (save to the file in REGEDIT4 format) ****

${registry::SaveKey} "[fullpath]" "[file]" "[Options]" $var

"[fullpath]"  - Registry path (Root\SubKey)

	Root:
	HKEY_CLASSES_ROOT      HKCR
	HKEY_CURRENT_USER      HKCU
	HKEY_LOCAL_MACHINE     HKLM
	HKEY_USERS             HKU
	HKEY_PERFORMANCE_DATA  HKPD
	HKEY_CURRENT_CONFIG    HKCC
	HKEY_DYN_DATA          HKDD

"[file]"      - Export to this file

"[Options]"   - "/A=[0|1] /D=[0|1|2] /N=[name] /G=[1|0] /B=[0|1]"

	/A=[0|1]
		/A=0  - Always create new file (default)
		/A=1  - Append data if file exists and
		        create new file if not

	/D=[0|1|2]
		/D=0  - Don't delete any keys (default)
		/D=1  - Delete only root key before restoring
		/D=2  - Delete keys before restoring

	/N=[name]
		             - Search for all values (default)
		/N=          - Search for empty value
		/N=version   - Search for exact value: "version"
		               can be in quotes "[name]", '[name]', `[name]`

	/G=[1|0]
		/G=1  - Search with subkeys (default)
		/G=0  - Don't search subkeys

	/B=[0|1]
		/B=0  - Don't show searching path (default)
		/B=1  - Show in the details current searching path

$var     0 - success
        -1 - error


**** Registry Import (restore from the file) ****

${registry::RestoreKey} "[file]" $var

$var     0 - success
        -1 - error

Note:
${registry::RestoreKey} simply exec regedit:  regedit /s "[file]"


**** StrToHex (converts string to hex values) ****

${registry::StrToHex} "[string]" $var

"[string]"  - String to convert

$var  - Hex string


**** HexToStr (converts hex values to string) ****

${registry::HexToStr} "[hex_string]" $var

"[string]"  - Hex string to convert

$var  - String


**** StrToHex (converts string to UTF-16LE hex values) ****

${registry::StrToHexUTF16LE} "[string]" $var

"[string]"  - String to convert

$var  - UTF-16LE Hex string


**** HexToStr (converts UTF-16LE hex values to string) ****

${registry::HexToStrUTF16LE} "[hex_string]" $var

"[string]"  - Hex string to convert

$var  - String


**** Unload plugin ****

${registry::Unload}
