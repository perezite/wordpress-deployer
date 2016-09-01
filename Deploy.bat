@echo off

rem ## show help if not enough arguments specified
IF [%2]==[] (
    echo usage:   Deploy.bat ^<local-directory^> ^<remote-directory^>
    echo example: Deploy.bat C:\XAMPP\htddocs\wordpress-dev ./httpdocs/wordpress
    exit /b
)

echo %1%
echo %2%


rem # Initialization
SET basePath=%~dp0

rem # Call win-scp script
SET winscpExecutable=%basePath:~0,-1%\winscp-portable\winscp.com
call %winscpExecutable% /script=Deploy.winscp /log="Script.log" /ini=nul /parameter %1 %2