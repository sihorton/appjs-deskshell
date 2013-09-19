REM start chrome
"..\..\bin\win\GoogleChromePortable\GoogleChromePortable.exe" --remote-debugging-port=9222 --user-data-dir=..\..\bin\win\chrome-profile
REM run node application
"..\..\bin\win\node.exe" node-backend/app.js 

pause