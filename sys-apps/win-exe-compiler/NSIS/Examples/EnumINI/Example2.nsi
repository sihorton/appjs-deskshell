; EnumINI plug-in example 2

Name "EnumINI Example"
OutFile "EnumFullINI.exe"
ShowInstDetails show

Section ""

  InitPluginsDir
  
  DetailPrint "EnumINI plug-in v0.13"
  DetailPrint ""

  EnumINI::SectionNames "enumtest.ini"
  Pop $R0
  StrCmp $R0 "error" done
  loop:
    IntCmp $R0 "0" done done 0
    Pop $R1
    DetailPrint "[$R1]"
    
    EnumINI::Section "enumtest.ini" "$R1"
    Pop $R2
    StrCmp $R2 "error" done2
    loop2:
      IntCmp $R2 "0" done2 done2 0
      Pop $R3
      ReadINIStr $R4 "$EXEDIR\enumtest.ini" "$R1" "$R3"
      DetailPrint "$R3 = $R4"
      IntOp $R2 $R2 - 1
	  Goto loop2
    done2:
    DetailPrint ""
    
    IntOp $R0 $R0 - 1
	Goto loop
  done:

SectionEnd
