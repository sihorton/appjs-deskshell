
EnumINI.dll v0.13 by TruePaRuEx
Build date: 21st December 2006
==============================

EnumINI plug-in retrieves all the sections or all the keys in specified section of an initialization (.ini) file. There is also functions to check if specified section or key, exist in initialization file.


Function usage:
---------------

EnumINI::Section [ini_filename] [section]

Enumerates section in the .ini file. Pushes each key name into stack and amount of keys found on top of the stack.

 [ini_filename]  : Path to the ini file.
 [section]       : Name of the section to enumerate.



EnumINI::SectionNames [ini_filename]

Enumerates section names in the .ini file. Pushes each section name into stack and amount of sections found on top of the stack.

 [ini_filename]  : Path to the ini file.



EnumINI::KeyExist [ini_filename] [section] [key]

Finds if key exist in the specified section. Pushes "1" in the stack if the key exist and "0" if the key doesn't exist.

 [ini_filename]  : Path to the ini file.
 [section]       : Name of the section.
 [key]           : Name of the key to search.



EnumINI::SectionExist [ini_filename] [section]

Finds if specified section exist in the .ini file. Pushes "1" in the stack if the section exist and "0" if the section doesn't exist.

 [ini_filename]  : Path to the ini file.
 [section]       : Name of the section to search.


About errors: String "error" is pushed in the stack if the specified section was not found, section was empty (EnumINI::KeyExist and EnumINI::Section), no sections was found at all (EnumINI::SectionExist) or the ini file could not be read.



Changelog:
==========

0.13 (21st December 2006)
 - Workaround for bug in GetPrivateProfileSection function (MS KB 198906) in Me/98/95 systems.
 - Code optimizations and base address changed to 0x600D0000. ;)

0.12 (19st August 2006)
 - Ini file comments are now filtered in Me/98/95 too.
 - Lines without '=' are filtered out.

0.1 (10st August 2006)
 - First release.

