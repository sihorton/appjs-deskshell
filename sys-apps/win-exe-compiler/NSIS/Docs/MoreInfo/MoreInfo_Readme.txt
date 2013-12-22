Goal of MoreInfo
----------------------------------------------
The goal of the MoreInfo NSIS Plugin is to CORRECTLY retreive version information from files.

   AND

to retreive the Windows OS User interface Language!

MoreInfo gives a complete valid NSIS Language define as an output. This can be any Language defined
and supported by NSIS and even some that are not recognized by Windows. (It is not necessary that the
host system actually support the locale with fonts, keyboard mappings, and so on.) 

The theory is that if the user can use the PC, he sure will be able to read the userinterface language.

This way we avoid asking the user for a installation language to use, and is the installer GUI
presented in the same language as the Windows OS User interface Language.

The current way of retreiving a Locale setting was not satisfying enough since a user could have an 
English Windows OS and set is locale to e.g. France, the installer would be presented in French this way,
although the GUI language was English. 

History
----------------------------------------------
A NSIS plugin called FileInfo sadly gave unexpected results on various Windows OS's.
This is how More Info was born... I needed correct information in all cases.
And I also needed the OS GUI language.

Since Windows has NO API to get the OS GUI language, I created this solution myself.
Maybe it can help you too.


MoreInfo Genecric Syntax
----------------------------------------------

	MoreInfo::<Function> <Filename>

Where:
 <Function> is one of the functions in the table below. ie: GetProductName
 <Filename> is a valid filename. ie: "C:\Windows\MyFile.dll"


	FunctionName			Comment
	-----------------------		----------------------------------------------------------

	GetComments			Get the Property known as "Comments"
	GetPrivateBuild			Get the Property known as "PrivateBuild"
	GetSpecialBuild			Get the Property known as "SpecialBuild"
	GetProductName			Get the Property known as "ProductName"
	GetProductVersion		Get the Property known as "ProductVersion"		
	GetCompanyName			Get the Property known as "CompanyName"
	GetFileVersion			Get the Property known as "FileVersion"
	GetFileDescription		Get the Property known as "FileDescription"
	GetInternalName			Get the Property known as "LegalCopyright"
	GetLegalCopyright		Get the Property known as "LegalCopyright"
	GetLegalTrademarks		Get the Property known as "LegalTrademarks"
	GetOriginalFilename		Get the Property known as "OriginalFilename"
	GetUserDefined			Get the Property known as "UserDefined"
	GetOSUserinterfaceLanguage	Get the Property known as "OSUserinterfaceLanguage"


MoreInfo Special Syntax
----------------------------------------------

	MoreInfo::GetUserDefined <Filename> <PropertyName>

Where:
 <Filename> is a valid filename. ie: "C:\Temp\MyFile.dll"
 <PropertyName> is a valid name of a property you want to obtain a value from. ie:"Language"

MoreInfo OS GUI Language Syntax
----------------------------------------------

	MoreInfo::GetOSUserinterfaceLanguage

The return value will contain the OS GUI Language suitable for NSIS

Return Values
----------------------------------------------
Just pop it off the stack.

If the property is found it's value will be returned. ie: "My Company"
If the property is not found it will be Null. ie: ""
Otherwise, the value returned will start with "Error:", followed by an error message. ie: "Error:Unable to allocate memory."


How the language will be determined
----------------------------------------------

When the installer starts up it goes through these steps to select the interface language:

   1. Get user's default Windows OS GUI language
   2. Find a perfect match for the langauge
   3. If there is no perfect match, find a primary language match
   4. If there is no match, use the first language defined in the script (make sure your first language is a common one like English)
   5. If the langauge variable $LANGUAGE has changed during .onInit, NSIS goes through steps 2 to 4 again, as in the case of this plugin.

As you can see the outcome of a chosen language is never un-expected.


Examples
----------------------------------------------
There are two examples

1) SimpleDemo
Shows of the basic functionality of MoreInfo

2) CustomLanguageDemo
Fully shows the power of getting the OS GUI language. I the demo a good example of how custompage localization works and could be implemented.


Info about LCID's
----------------------------------------------
The LCID, or "locale identifer," is a 32-bit data type into which are packed several
different values that help to identify a particular geographical region. One of 
these internal values is the "primary language ID" which identifies the basic 
language of the region or locale, such as English, Spanish, or Turkish.

For conversion from LCID to NSIS Language define we use the following table. 
The table lists some common LCIDs as well as well as some less common ones that are
valid for NSIS even through Windows does not recognize them by default. Note that 
this is this probably not a complete list of all possible LCIDs. Feel free to improve
the list below.

Some Valid LCIDs. (Note: $ in front means the value is in Hexidecimal notation )

Afrikaans			$0436
Albanian			$041c
Arabic (Algeria)		$1401
Arabic (Bahrain)		$3c01
Arabic (Egypt)			$0c01
Arabic (Iraq)			$0801
Arabic (Jordan)			$2c01
Arabic (Kuwait)			$3401
Arabic (Lebanon)		$3001
Arabic (Libya)			$1001
Arabic (Morocco)		$1801
Arabic (Oman)			$2001
Arabic (Qatar)			$4001
Arabic (Saudi Arabia)		$0401
Arabic (Syria)			$2801
Arabic (Tunisia)		$1c01
Arabic (U.A.E.)			$3801
Arabic (Yemen)			$2401
Basque				$042d
Belarusian			$0423
Bulgarian			$0402
Catalan				$0403
Chinese (Hong Kong SAR)		$0c04
Chinese (PRC)			$0804
Chinese (Singapore)		$1004
Chinese (Taiwan)		$0404
Croatian			$041a
Czech				$0405
Danish				$0406
Dutch (Belgian)			$0813
Dutch (Standard)		$0413
English (Australian)		$0c09
English (Belize)		$2809
English (Canadian)		$1009
English (Caribbean)		$2409
English (Ireland)		$1809
English (Jamaica)		$2009
English (New Zealand)		$1409
English (South Africa)		$1c09
English (Trinidad)		$2c09
English (United Kingdom)	$0809
English (United States)		$0409
Estonian			$0425
Faeroese			$0438
Farsi				$0429
Finnish				$040b
French (Belgian)		$080c
French (Canadian)		$0c0c
French (Luxembourg)		$140c
French (Standard)		$040c
French (Swiss)			$100c
German (Austrian)		$0c07
German (Liechtenstein)		$1407
German (Luxembourg)		$1007
German (Standard)		$0407
German (Swiss)			$0807
Greek				$0408
Hebrew				$040d
Hungarian			$040e
Icelandic			$040f
Indonesian			$0421
Italian (Standard)		$0410
Italian (Swiss)			$0810
Japanese			$0411
Korean				$0412
Korean (Johab)			$0812
Latvian				$0426
Lithuanian			$0427
Malay (Malaysian)		$043e
Malay (Brunei)			$083e
Norwegian (Bokmal)		$0414
Norwegian (Nynorsk)		$0814
Polish				$0415
Portuguese (Brazil)		$0416
Portuguese (Portugal)		$0816
Romanian			$0418
Russian				$0419
Serbian (Cyrillic)		$0c1a
Serbian (Latin)			$081a
Slovak				$041b
Slovenian			$0424
Spanish (Argentina)		$2c0a
Spanish (Bolivia)		$400a
Spanish (Chile)			$340a
Spanish (Colombia)		$240a
Spanish (Costa Rica)		$140a
Spanish (Dominican Republic)	$1c0a
Spanish (Ecuador)		$300a
Spanish (El Salvador)		$440a
Spanish (Guatemala)		$100a
Spanish (Honduras)		$480a
Spanish (Mexican)		$080a
Spanish (Modern Sort)		$0c0a
Spanish (Nicaragua)		$4c0a
Spanish (Panama)		$180a
Spanish (Paraguay)		$3c0a
Spanish (Peru)			$280a
Spanish (Puerto Rico)		$500a
Spanish (Traditional Sort)	$040a
Spanish (Uruguay)		$380a
Spanish (Venezuela)		$200a
Swahili				$0441
Swedish				$041d
Swedish (Finland)		$081d
Thai				$041e
Turkish				$041f
Ukrainian			$0422

Several CD/DVD methods and properties return locale identifier (LCID) values that identify which
languages are available on the soundtracks or subtitles. To make use of this information, your
application will need to extract the primary language ID from the returned LCID. To do this,
perform a bitwise AND operation on the value of iLCID and $3FF. (The primary language ID is
contained in the least significant 10 bits of the LCID.) The following code snippet shows how to
do this.

iPrimaryLang = iLCID & $3FF;

To obtain a human-readable string from the primary language ID, call GetLangFromLangID as shown
in this example: 

sLanguage = DVD.GetLangFromLangID(iPrimaryLang);

See the Microsoft® Platform SDK for more information on LCIDs and language identifiers. 
The following list shows the primary language IDs for the LCIDs in the table above.
 
Some Valid Primary Language IDs

Afrikaans	$36
Albanian	$1c
Arabic		$01
Basque		$2d
Belarusian	$23
Bulgarian	$02
Catalan		$03
Chinese		$04
Croatian	$1a
Czech		$05
Danish		$06
Dutch		$13
English		$09
Estonian	$25
Faeroese	$38
Farsi		$29
Finnish		$0b
French		$0c
German		$07
Greek		$08
Hebrew		$0d
Hungarian	$0e
Icelandic	$0f
Indonesian	$21
Italian		$10
Japanese	$11
Korean		$12
Latvian		$26
Lithuanian	$27
Malay		$3e
Norwegian	$14
Polish		$15
Portuguese	$16
Romanian	$18
Russian		$19
Serbian		$1a
Slovak		$1b
Slovenian	$24
Spanish		$0a
Swahili		$41
Swedish		$1d
Thai		$1e
Turkish		$1f
Ukrainian	$22
 
Source
----------------------------------------------
Freeware, can be used anywhere by anyone, or whatever license Nullsoft has bound their wrapper with,
most of the rest came from the top of my head. See the source for possible more information.

Built with Borland Delphi v7.1.1
http://www.borland.com/delphi/


Success with building customer friendly installations!


E.Onad



