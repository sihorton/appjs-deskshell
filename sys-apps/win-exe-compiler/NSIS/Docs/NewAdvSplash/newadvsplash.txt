NewAdvSplash.dll - plug-in that lets you throw 
up a splash screen in NSIS installers with 
fading effects (win2k/xp) and transparency.
At the same time can play wav-mp3 sound file. 

Usage:

1)   newadvsplash::show [/NOUNLOAD] Delay FadeIn FadeOut KeyColor [/BANNER] [/PASSIVE] [/NOCANCEL] FileName

Delay - time (milliseconds) to show image
FadeIn - time to show the fadein scene
FadeOut - time to show the fadeout scene
KeyColor - color used for transparency, could be any RGB value 
   (for ex. R=255 G=100 B=16 -> KeyColor=0xFF6410), 
   use KeyColor=-1 if there is no transparent color at your image.
   If KeyColor=-2 and image type is gif, plug-in attempts to extract 
   transparency color value from the file header. For gif images 
   transparency on the static background works even if KeyColor=-1.
/BANNER - returns control to installer immediatelly after plug-in 
   activation.
/NOCANCEL - disables 'exit on user click' default behaviour.
/PASSIVE - not forces splash window to foreground.
FileName - splash image filename (with extension!). Bmp, gif and jpg
   image types are supported.

For example:

     newadvsplash::show 3000 0 0 -2 "$PLUGINSDIR\catch.gif"
or
     newadvsplash::show /NOUNLOAD 1000 600 400 0xFF6410 /BANNER "$TEMP\spltmp.bmp"

    Use /NOUNLOAD with /BANNER key - this case plug-in not waits for
    the end of 'show' and returns control to installer. If used in .onInit
    function, /BANNER key requires 'ShowWindow $HWNDPARENT 2' in .onGUIInit


2)   newadvsplash::wait

     Waits for the end of performance :). If 'show' already finished - 
     exits immediately


3)   newadvsplash::stop

     Terminates banner.


4)   newadvsplash::play /NOUNLOAD [/LOOP] FileName

FileName - sound filename to play (with extension, wav, mp3 ...).
Empty Filename string "" stops sound.
For example:

     newadvsplash::play /NOUNLOAD /LOOP "$PLUGINSDIR\snd.mp3"
     newadvsplash::show 2000 1000 500 -1 "$PLUGINSDIR\iamfat.jpg"


4)   newadvsplash::hwnd /NOUNLOAD

Gets splash window handle.
For example:

     newadvsplash::hwnd /NOUNLOAD
     Pop $0 ; $0 is window handle now

Compatibility:
Basic - Win95 and later.
Fadein/fadeout - win2k/winxp.

Original code - Justin
Converted to a plugin DLL by Amir Szekely (kichik)
Fading and transparency by Nik Medved (brainsucker)
Gif and jpeg support, /BANNER and /CANCEL, mp3 support - Takhir Bedertdinov
