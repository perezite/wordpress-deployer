@echo off 

rem ## show help if not enough arguments specified
IF [%6]==[] (
    echo usage:   Deploy.bat ^<host^> ^<user^> ^<local-directory^> ^<remote-directory^> ^<database-name^> ^<mysql-bin-directory^>
    echo example: Deploy.bat host.mywepage.com root C:\XAMPP\htddocs\wordpress-dev ./httpdocs/wordpress wordpress C:\mysql\bin
    exit /b
)

rem # strip quotes from parameters
SET hostParameter=%1%
SET host=%hostParameter:~1,-1%
SET userParameter=%2%
SET user=%userParameter:~1,-1%
SET dbNameParameter=%5%
SET dbName=%dbNameParameter:~1,-1%
SET mysqlBinDirParameter=%6%
SET mysqlBinDir=%mysqlBinDirParameter:~1,-1%

rem # get webpage password
SET /p webpagePassword="Please enter the webpage password: "

rem # Initialization
SET basePath=%~dp0

rem # Call win-scp script
SET winscpExecutable=%basePath:~0,-1%\winscp-portable\winscp.com
echo Enter Webpage password:
call %winscpExecutable% /script=DeployWebpage.winscp /log="DeployWebpage.log" /ini=nul /parameter %1 %2 %3 %4 %webpagePassword%

rem # Deploy the database
SET mysqldumpExecutable=%mysqlBinDir%\mysqldump.exe
SET mysqlExecutable=%mysqlBinDir%\mysql.exe

call "%mysqldumpExecutable%" -h localhost -u root %dbName% > DatabaseDump.sql
echo Enter Database password:
call "%mysqlExecutable%" -h %host% -u %user% -p -e "drop database if exists %dbName%; create database %dbName%;"
echo Enter Database password again:
call "%mysqlExecutable%" -h %host% -u %user% -p %dbName% < DatabaseDump.sql

rem # Cleanup
cd %basePath%

rem # Goodbye message
echo Done. Don't forget to upload the wp-config.php manually after the very first deployment!
pause
