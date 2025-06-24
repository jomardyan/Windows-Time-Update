@echo off
:: PolicyUpdate.bat - Advanced Group Policy Update Script
:: Logs, admin check, restart option, last update time, error handling

setlocal EnableDelayedExpansion
set LOGFILE=%~dp0PolicyUpdate.log

:: Check for admin rights
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator.
    pause
    exit /b 1
)

:: Display user and computer info
echo =============================================
echo Group Policy Update Utility
echo =============================================
echo User: %USERNAME%
echo Computer: %COMPUTERNAME%
echo Date: %DATE% %TIME%
echo ---------------------------------------------

:: Show last policy update time (from event log, if available)
for /f "skip=1 tokens=*" %%A in ('wevtutil qe System /q:"*[System[(EventID=1502)]]" /rd:true /c:1 /f:text 2^>nul ^| findstr /i "Date:"') do set LASTUPDATE=%%A
if defined LASTUPDATE (
    echo Last Group Policy update: !LASTUPDATE!
) else (
    echo Last Group Policy update: [Not available]
)
echo ---------------------------------------------

:: Log start
echo [%DATE% %TIME%] Starting Group Policy update... >> "%LOGFILE%"

echo Updating Group Policy...
gpupdate /force > "%TEMP%\gpupdate_output.txt" 2>&1
set GPERR=%ERRORLEVEL%
type "%TEMP%\gpupdate_output.txt"
type "%TEMP%\gpupdate_output.txt" >> "%LOGFILE%"
del "%TEMP%\gpupdate_output.txt" >nul 2>&1

if %GPERR% neq 0 (
    echo [ERROR] Group Policy update failed with error code %GPERR%.
    echo [%DATE% %TIME%] ERROR: gpupdate failed with code %GPERR% >> "%LOGFILE%"
    pause
    exit /b %GPERR%
)

echo.
echo Group Policy update completed successfully.
echo [%DATE% %TIME%] Group Policy update completed successfully. >> "%LOGFILE%"

:: Offer restart if required
choice /c YN /n /m "Do you want to restart the computer now (required for some policies)? [Y/N]: "
if errorlevel 2 goto end
echo Restarting...
shutdown /r /t 5
goto :eof

:end
echo Exiting without restart.
endlocal
pause