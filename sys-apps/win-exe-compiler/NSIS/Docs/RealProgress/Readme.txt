~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~ RealProgress.dll  v0.4 (6.5KB)
~ Written by Afrow UK

~ NSIS C++ plugin that allows control over the progress bar
~ positioning on the InstFiles page.

~   Last build: 31st May 2007, Microsoft Visual C++ 6


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Plugin Functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 RealProgress::UseProgressBar /NOUNLOAD control_id

  Sets which progress bar control id (msctls_progress32) to use.
  Do not use this unless you have added a new one, or want to use the
  existing NSIS one.
  By default, when not using this, the plugin will create its own
  progress bar control where the original NSIS one is.

  /NOUNLOAD is required.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::GetProgress /NOUNLOAD [/ORIGINAL]
 Pop $Var

  Returns the current position of the progress bar in $Var.
  Use the optional /ORIGINAL switch to get the
  position of the underlying (old) progress bar.

  /NOUNLOAD is required.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::SetProgress /NOUNLOAD val

  Directly sets the progress bar position to (val) where (val)
  is an integer value.
  E.g. 25 would set the progress bar to 25% complete.

  /NOUNLOAD is required.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::AddProgress /NOUNLOAD val

  Increases the current progress bar value by (val) where (val)
  is an integer value.

  /NOUNLOAD is required.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::DetailProgress /NOUNLOAD item_count increase_by

  Increases the progress bar through (item_count) detail prints
  in the log window to (increase_by)%.

  For example, if we use File /r, it will output many SetOutPath and
  File instruction details. If we have say 20 files and 10
  directories, (item_count) could be 30.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::FileProgress /NOUNLOAD increase_by

  Increases the progress bar to (increase_by)% gradually while the
  proceding file is being extracted.

  For example, for larger files, a larger (increase_by) value should
  be used.

  /NOUNLOAD is required.

  * Example:
   RealProgress::FileProgress /NOUNLOAD 60
   File "120MB_File.ext"

   RealProgress::FileProgress /NOUNLOAD 40
   File "80MB_File.ext"

  This includes two files that together add up to 200MB, and
  add up to make 100% of the installation progress (60+40).
  The first file is the larger of the two and therefore should
  have a larger (increase_by) value (60) so that it moves
  the progress bar furthest out of the two.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 RealProgress::GradualProgress /NOUNLOAD increase_per_second \
                                         increase_by \
                                         increase_to_position \
                                         [until_detail_reached]

  Performs a gradual progression until the (increase_to_position)
  value is met, or a new item is added to the InstFiles log window,
  or until an item is added of text [until_detail_reached]
  (if the optional parameter is used).

  The gradual progression will move (increase_by)% every
  (increase_per_second) seconds until the above condition is met.

  (increase_to_position)% will always be met.

  (increase_per_second), (increase_by) and (increase_to_position)
  must all be integer values.

  /NOUNLOAD is required.

  * Example 1:
   RealProgress::GradualProgress /NOUNLOAD 1 \
                                           10 \
                                           100

  Performs a gradual progression from 0 to 100%,
  increasing the progress by by 10% every second.

  * Example 2:
   RealProgress::GradualProgress /NOUNLOAD 1 \
                                           10 \
                                           100 \
                                           "Stop now!"

  Performs a gradual progression from 0 to 100%, or until
  "Stop now!" is printed in the InstFiles log window (with
  DetailPrint) which will result in the progress bar
  jumping to 100% immediately.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Examples
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 See Examples\RealProgress\ExampleMUI.nsi


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Unloading The Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 Unless the plugin is unloaded, it will remain undeleted in the
 $PLUGINSDIR directory.

 Use the following code in your NSI script to unload the plugin:

 Function .onGUIEnd
  RealProgress::Unload
 FunctionEnd


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Change Log
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

v0.4 [31st May 2007]
* Added UseProgressBar function.

v0.3 [25th May 2006]
* Added DetailProgress function.

v0.2 [18th January 2006]
* Fixed problems with GradualProgress.

v0.1
* First release.