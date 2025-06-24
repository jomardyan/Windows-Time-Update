@echo off
setlocal enabledelayedexpansion

REM =======================================================
REM Windows Time Update Script - Advanced Version
REM Features: NTP sync, service management, configuration,
REM          status checking, and multiple NTP servers
REM =======================================================

title Windows Time Synchronization Tool

:MAIN_MENU
cls
echo ========================================
echo   Windows Time Synchronization Tool
echo ========================================
echo.
echo Current Date/Time: %date% %time%
echo.
echo 1. Quick Time Sync (Resync)
echo 2. Check Time Service Status
echo 3. Start/Stop Windows Time Service
echo 4. Configure NTP Server
echo 5. Show Current Configuration
echo 6. Force Immediate Sync
echo 7. Sync with Multiple Servers
echo 8. Check Time Difference
echo 9. Reset Time Configuration
echo 0. Exit
echo.
set /p choice="Select an option (0-9): "

if "%choice%"=="1" goto QUICK_SYNC
if "%choice%"=="2" goto CHECK_STATUS
if "%choice%"=="3" goto MANAGE_SERVICE
if "%choice%"=="4" goto CONFIG_NTP
if "%choice%"=="5" goto SHOW_CONFIG
if "%choice%"=="6" goto FORCE_SYNC
if "%choice%"=="7" goto MULTI_SYNC
if "%choice%"=="8" goto CHECK_DIFF
if "%choice%"=="9" goto RESET_CONFIG
if "%choice%"=="0" goto EXIT
goto MAIN_MENU

:QUICK_SYNC
cls
echo Performing quick time synchronization...
echo.
w32tm /resync
if %errorlevel% equ 0 (
    echo [SUCCESS] Time synchronized successfully!
    echo New time: %date% %time%
) else (
    echo [ERROR] Time synchronization failed. Error code: %errorlevel%
    call :ERROR_HELP
)
pause
goto MAIN_MENU

:CHECK_STATUS
cls
echo Checking Windows Time Service status...
echo.
sc query w32time
echo.
echo Time Service Configuration:
w32tm /query /status
echo.
pause
goto MAIN_MENU

:MANAGE_SERVICE
cls
echo Current Windows Time Service Status:
sc query w32time | find "STATE"
echo.
echo 1. Start Windows Time Service
echo 2. Stop Windows Time Service
echo 3. Restart Windows Time Service
echo 4. Back to Main Menu
echo.
set /p svc_choice="Select service action (1-4): "

if "%svc_choice%"=="1" (
    echo Starting Windows Time Service...
    net start w32time
) else if "%svc_choice%"=="2" (
    echo Stopping Windows Time Service...
    net stop w32time
) else if "%svc_choice%"=="3" (
    echo Restarting Windows Time Service...
    net stop w32time
    timeout /t 2 /nobreak >nul
    net start w32time
) else if "%svc_choice%"=="4" (
    goto MAIN_MENU
)
echo.
pause
goto MAIN_MENU

:CONFIG_NTP
cls
echo Configure NTP Server
echo.
echo Popular NTP Servers:
echo 1. time.windows.com (Default)
echo 2. pool.ntp.org
echo 3. time.nist.gov
echo 4. time.google.com
echo 5. Custom server
echo 6. Back to Main Menu
echo.
set /p ntp_choice="Select NTP server (1-6): "

if "%ntp_choice%"=="1" set "ntp_server=time.windows.com"
if "%ntp_choice%"=="2" set "ntp_server=pool.ntp.org"
if "%ntp_choice%"=="3" set "ntp_server=time.nist.gov"
if "%ntp_choice%"=="4" set "ntp_server=time.google.com"
if "%ntp_choice%"=="5" (
    set /p ntp_server="Enter custom NTP server: "
)
if "%ntp_choice%"=="6" goto MAIN_MENU

if defined ntp_server (
    echo Configuring NTP server to: %ntp_server%
    w32tm /config /manualpeerlist:"%ntp_server%" /syncfromflags:manual /reliable:yes /update
    if %errorlevel% equ 0 (
        echo [SUCCESS] NTP server configured successfully!
        echo Restarting Windows Time Service...
        net stop w32time >nul 2>&1
        net start w32time >nul 2>&1
        echo Service restarted. Performing initial sync...
        w32tm /resync
    ) else (
        echo [ERROR] Failed to configure NTP server.
    )
)
pause
goto MAIN_MENU

:SHOW_CONFIG
cls
echo Current Time Configuration:
echo =============================
echo.
w32tm /query /configuration
echo.
echo Peer Information:
w32tm /query /peers
echo.
pause
goto MAIN_MENU

:FORCE_SYNC
cls
echo Force immediate synchronization...
echo.
echo Stopping Windows Time Service...
net stop w32time >nul 2>&1
echo Starting Windows Time Service...
net start w32time >nul 2>&1
echo Forcing time sync...
w32tm /resync /force
if %errorlevel% equ 0 (
    echo [SUCCESS] Forced synchronization completed!
    echo Updated time: %date% %time%
) else (
    echo [ERROR] Forced synchronization failed.
    call :ERROR_HELP
)
pause
goto MAIN_MENU

:MULTI_SYNC
cls
echo Synchronizing with multiple NTP servers...
echo.
set "servers=time.windows.com pool.ntp.org time.nist.gov time.google.com"
for %%s in (%servers%) do (
    echo Trying server: %%s
    w32tm /stripchart /computer:%%s /samples:1 /dataonly
    echo.
)
echo.
echo Performing final resync...
w32tm /resync
pause
goto MAIN_MENU

:CHECK_DIFF
cls
echo Checking time difference with NTP servers...
echo.
echo Comparing with time.windows.com:
w32tm /stripchart /computer:time.windows.com /samples:3 /dataonly
echo.
echo Comparing with pool.ntp.org:
w32tm /stripchart /computer:pool.ntp.org /samples:3 /dataonly
echo.
pause
goto MAIN_MENU

:RESET_CONFIG
cls
echo WARNING: This will reset Windows Time configuration to defaults!
echo.
set /p confirm="Are you sure? (y/N): "
if /i not "%confirm%"=="y" goto MAIN_MENU

echo Resetting Windows Time configuration...
w32tm /unregister
w32tm /register
net stop w32time >nul 2>&1
net start w32time >nul 2>&1
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:yes /update
w32tm /resync
echo [SUCCESS] Configuration reset to defaults.
pause
goto MAIN_MENU

:ERROR_HELP
echo.
echo Troubleshooting Tips:
echo - Ensure you're running as Administrator
echo - Check internet connectivity
echo - Verify Windows Time service is running
echo - Check firewall settings (NTP uses UDP port 123)
echo - Try different NTP servers if current one is unreachable
goto :eof

:EXIT
cls
echo Exiting Windows Time Synchronization Tool...
echo Final time: %date% %time%
echo.
echo Thank you for using this tool!
timeout /t 2 /nobreak >nul
exit /b 0
