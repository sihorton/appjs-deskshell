~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  EmbeddedLists.dll v1.4 RC2 by Afrow UK

   An NSIS plug-in to display list view and tree view controls from INI
   files.

   Last build: 8th July 2010

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 Place Plugins\EmbeddedLists.dll in your NSIS\Plugins folder or
 Unicode\Plugins\EmbeddedLists.dll in your NSIS\Unicode\Plugins folder
 simply extract all files in the Zip to NSIS\

 See Examples\EmbeddedLists for examples of use.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Displaying the dialogs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  EmbeddedLists::Dialog "el_file.ini"
   Pop $Var

   "el_file.ini" : Path to EmbeddedLists INI file.

  This is the normal way to call the plugin.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  EmbeddedLists::InitDialog "el_file.ini"
   Pop $HWNDVar
  EmbeddedLists::Show
   Pop $Var

   "el_file.ini" : Path to EmbeddedLists INI file.

  This method allows you to modify controls on the dialog with
  SendMessage, SetCtlColors etc by using the $HWNDVar between the
  InitDialog and Show calls and also in the Page's Leave function.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  At this point, $Var will contain "ERROR" on display error,
  "NEXT" if the next button has been pressed,
  "BACK" if the back button has been pressed or
  "CANCEL" if the cancel button has been pressed.

  Further Pop's are necessary in the page's leave function to access
  selected or checked items. To mark the end of the list, "/END" will
  be on the stack.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 INI file section [Settings]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  The [Settings] section contains initialisation attributes
  for the plugin.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to both plugin dialogs...

   Type=ListView|TreeView - Dialog type.
   HeadingText=(text)     - Text to display in the heading label.
   GroupText=(text)       - Text to display in the group box.
   Caption=(text)         - Text to be displayed in installer caption.
   ReturnItemText=0|1     - Item text for selected/checked items are
                             returned on page leave. Otherwise, by
                             default, item numbers are returned (added
                             v0.9).
   LabelEdit=0|1          - Enable item label editing.
   CheckBoxes=0|1         - Items have check boxes.
   ToggleNextButton=0|1   - The Next button remains disabled until an
                             item is checked or selected.
   NoItemSelection=0|1    - No items can be selected.
   Rect=(rect_id)         - The black rectangle to display the dialog
                             on. Default is 1018.
   ViewListOnly=0|1       - The list control is stretched to fit the
                             entire window. The heading label and group
                             box are destroyed.
   UseCheckBitmap=0|1|path- The check bitmap from the NSIS components
                             page is used for check box state images.
                             This allows EmbeddedLists to support the
                             same check states as the components page
                             (added v1.0). If you are not using a
                             components page in your installer then
                             specify a full file path instead.
                             This setting is on by default.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to just the ListView dialog...

   ColumnHeader=0|1       - List has column headings.
   SingleSelect=0|1       - Only one list item can be selected at the
                             same time.
   Sort=none|             - Sort list view items.
        ascending|
        descending
   SortByColumn=#         - Initial column for items to be sorted by,
                             where # is an integer value starting at 1.
   SortByColumnClick=0|1  - Column headers are clickable. Allows items
                             to be sorted by individual columns.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to just the TreeView dialog.

   ParentCheck=0|1        - Checking or unchecking the check boxes of
                             parent nodes check or uncheck all child
                             nodes as well. Parent nodes are also
                             checked or unchecked if all or none of the
                             child nodes are checked (added v0.9).

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 INI file section [Icons]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  The [Icons] section defines a list of icon (.ico) files
  to be used beside ListView & TreeView items.

   IconCount=#            - Number of icons in list. Use is not
                             mandatory but wise.
   Icon#=(file path)      - Specifies the full path to an icon file.
                             # is an integer value starting from 1.

  Example:

  [Icons]
  IconCount=3
  Icon1=x:\path\to\icon1.ico
  Icon2=x:\path\to\icon2.ico
  Icon3=x:\path\to\icon3.ico

  Note: To set the icon paths at run time, use the WriteINIStr
        instruction before displaying the dialog.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 INI file section [Columns]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  This section sets the ListView column headers...

   Column#=(text)         - Creates a column and sets its header text.
                             # is an integer value starting from 1.
   Column#Width=(width)   - Sets the column width in units.
                             The width value must be an integer value.
                             # is an integer value starting from 1.

  Example:

  [Columns]
  Column1=My column 1!
  Column1Width=250
  Column2=Column 2!
  Column2Width=100

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 INI file section [Item #]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  The [Item #] section creates a ListView or TreeView item.
  # is an integer value starting from 1, incrementing by 1 for
  each item.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to both plugin dialogs...

   Text=(text)            - The text for the item.
   IconIndex=#            - The index of the icon to be placed to the
                             left of the item, starting from 1.
                             Icons are created under the [Icon] section
                             further up in this readme.
   Checked=0|1            - Sets the check state of the item check box.
   DisableCheck=0|1|2     - Check box states cannot be changed and
                             remain the same as set in the INI file.
                             If 2, the check box will be hidden when a
                             check bitmap is in use.
   DisableLabelEdit=0|1   - This item label cannot be edited. Useful
                             when using LabelEdit=1 under [Settings].

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to the ListView dialog...

   SubItem#=(text)        - Item text to set under column #. # is an
                             integer value starting from 1, where 1 is
                             the first column.
   Selected=0|1           - Sets the selection state for the item.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  These attributes apply to the TreeView dialog...
  We refer to items as 'nodes' as well.

   Position=#             - Sets the indentation of nodes and their
                             proceding nodes. Used to create parent and
                             child nodes where child nodes appear inside
                             a parent node.
   Expanded=0|1           - Sets the expanded state if the node is a
                             parent node with other child nodes.
   BoldText=0|1           - The node's text is bold.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Change Log
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  v1.4 - 8th July 2010
  * Removed DLL manifest to fix Microsoft VC90 CRT dependency.
  * Now using ANSI pluginapi.lib for non Unicode build.
  * RC2: Added version information resource.

  v1.3 - 30th March 2010
  * Minor code cleanup.
  * Changed example scripts to MUI2.
  * Added Unicode build.

  v1.2 - 14th July 2007
  * Added LVS_EX_LABELTIP extended style to list view.

  v1.1 - 25th June 2007
  * Added DisableCheck=2 to hide check boxes when a check bitmap is in
    use.
  * Fixed problems with ParentCheck=1.

  v1.0 - 2nd June 2007
  * Added right click menus with options for selecting and checking
    items/nodes.
  * Added support for the NSIS components page check bitmap allowing
    disabled and partially checked images.
  * Fixed many problems with check boxes when not using the check
    bitmap.
  * Cleaned up and utilised a lot of code.

  v0.9 - 31st May 2007
  * Parent tree nodes are now checked/unchecked if all child nodes are
    checked/unchecked.
  * The default return value for selected/checked items is now the item
    number, not the item text. Using ReturnItemText in the Settings INI
    file section uses the old style.

  v0.8 - 22nd July 2006
  * 32-bit icons are now displayed properly.

  v0.7 - 11th July 2006
  * Added better support for custom UI sizes.
  * Font is now taken from parent window instead of the system.

  v0.6 - 9th June 2006
  * Added Rect INI file setting.
  * Added ViewListOnly INI file setting.

  v0.5 - 25th May 2006
  * Fixed returning of selected & checked items.
  * Selected=# now works properly.
  * Label edit is now saved for TreeView.

  v0.4 - 24th May 2006
  * Major changes.
  * Plugin now uses INI files.

  v0.3
  * Fixed crashing.

  v0.2
  * Recompiled under VC++6 in attempt to fix crash.

  v0.1
  * First build.