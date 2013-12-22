Description

Plug-in works with console applications - creates hidden child process with redirected i/o. Compare to NSISdl has 4 add-ons: 1) string parameter that serves as stdin for running application; 2) sync/async process launch option; 3) works out of section as well; 4) multithreading.  First may be useful if you want to give login/password to the running application, second - for long running applications, third - for .onInit function check outs, fourth - to run few DOS application at a time. Plug-in can put application output to log file, 'detailed' installer window, any other text window, to installer stack or call script function to handle every line. Maximim input string size is 8kB in the special NSIS build, 1 kB otherwise.


How To Use

  ExecDos::exec [/ASYNC] [/TIMEOUT=xxx] [/TOSTACK | /DETAILED | /TOWINDOW | /TOFUNC] [/ENDFUNC=func] [/DISABLEFSR] application_to_run [stdin_string] [log_file_name | window | function]

  /ASYNC - not waits for process exit. Use 'wait' to get exit code
  /TIMEOUT - TOTAL execution time, milliseconds, for example /TIMEOUT=10000. 
            Default is big enough. Short timeouts may cause app to be terminated. 
  /TOSTACK - puts not empty output lines to stack (not reads log_file_name parameter from stack)
  /DETAILED - puts output lines to installer' detailed window
  /TOWINDOW - adds output lines to target window. Edit, RichEdit, ListView and ListBox supported
  /TOFUNC - pushes output lines to installer stack and calls script function
  /DISABLEFSR - disables WOW64 file system redirection on x64 machines for the ExecDos internal thread
  application_to_run - application to run (required)
  stdin_string - all that application can get from stdin (optional)
  log_file_name - file where to put app's stdout (optional) OR target window handle OR script function pointer
Please note - last 2 parameters are optional if installer stack is empty. More safe to use "" for unused parameters in case the stack is not empty. If you find a random file appearing during install then this is why (i.e. log_file_name)!

  ExecDos::wait HANDLE
  HANDLE - for async mode only, thread handle to wait for. Returnes application exit code or error code.

  ExecDos::isdone HANDLE
  HANDLE - for async mode only, checks thread is running. Returns 1 if application have exited, 0 if still running, -1 on error.


Example of async launch

  ExecDos::exec /ASYNC "$EXEDIR\consApp.exe" "test_login$\ntest_pwd$\n" "$EXEDIR\execdos.log"
  Pop $0 ; thread handle for 'wait'.
  ExecDos::wait $0
  Pop $0 ; exit code
  MessageBox MB_OK "Exit code $0"

sync launch

  ExecDos::exec "$EXEDIR\consApp.exe" "" ""
  Pop $0 ; exit code
  MessageBox MB_OK "Exit code $0"


BAT files specifics

On some of Win98 systems "Close on exit" option is not set for DOS apps. As a result after batch execution was finished (and installer continue it's job) hidden window still remains in the system as "winoldapp". Following two lines solve the problem 

@echo off
# place your bat code here
cls

Telnet and ssh - Plug-in not works with applications requiring terminal emulation.


Takhir Bedertdinov, INEUM, Moscow, Russia
Stuart 'Afrow UK' Welch, Birmingham, UK, afrowuk@tiscali.co.uk

