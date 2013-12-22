; EnumINI plug-in example

Name "EnumINI Example"
OutFile "EnumINI.exe"
ShowInstDetails show

Section ""

  InitPluginsDir
  
  DetailPrint "EnumINI plug-in v0.13"
  DetailPrint ""

  
  DetailPrint "Let's enumerate keys in $\"EXAMPLE_ONE$\" section"

  EnumINI::Section "enumtest.ini" "EXAMPLE_ONE"
  Pop $R0

  DetailPrint "Keys in stack: $R0"
  StrCmp $R0 "error" done

  loop:
    IntCmp $R0 "0" done done 0
    Pop $R1
    DetailPrint "$R1"
    IntOp $R0 $R0 - 1
	Goto loop
  done:
  DetailPrint ""


  DetailPrint "Let's enumerate sections in .ini file"

  EnumINI::SectionNames "enumtest.ini"
  Pop $R0

  DetailPrint "Sections in stack: $R0"
  StrCmp $R0 "error" done2

  loop2:
    IntCmp $R0 "0" done2 done2 0
    Pop $R1
    DetailPrint "$R1"
    IntOp $R0 $R0 - 1
	Goto loop2
  done2:
  DetailPrint ""


  DetailPrint "Let's find out if key $\"fairlight$\" exist in $\"EXAMPLE_ONE$\" section"

  EnumINI::KeyExist "enumtest.ini" "EXAMPLE_ONE" "fairlight"
  Pop $R0
  DetailPrint "In stack we have: $R0"
  StrCmp $R0 "1" 0 +3
  DetailPrint "And the key exist :)"
  Goto +3
  StrCmp $R0 "0" +2
  DetailPrint "And key doesn't exist :("
  DetailPrint ""

  
  DetailPrint "Let's find out if section $\"EXAMPLE_TWO$\" exist in .ini file"

  EnumINI::SectionExist "enumtest.ini" "EXAMPLE_TWO"
  Pop $R0
  DetailPrint "In stack we have: $R0"
  StrCmp $R0 "1" 0 +3
  DetailPrint "And the section exist :)"
  Goto +3
  StrCmp $R0 "0" +2
  DetailPrint "And section doesn't exist :("
  DetailPrint ""
  

  DetailPrint "Let's test stuff ;)"
  
  EnumINI::Section "enumtest.ini" "TEST STUFF"
  Pop $R2
  StrCmp $R2 "error" done3
  loop3:
    IntCmp $R2 "0" done3 done3 0
    Pop $R3
    ReadINIStr $R4 "$EXEDIR\enumtest.ini" "TEST STUFF" "$R3"
    DetailPrint ">$R3< = >$R4<"
    IntOp $R2 $R2 - 1
  Goto loop3
  done3:
  DetailPrint ""

SectionEnd
