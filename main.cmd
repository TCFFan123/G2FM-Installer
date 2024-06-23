@echo off
title G2FM Installer
color 1f
echo Welcome to the G2FM Installer!
echo Original installer is by QuestYouCraft.
for /f "tokens=2 delims=[]" %%i in ('ver') do (@for /f "tokens=2 delims=. " %%a in ("%%i") do set "n=%%a")
if %n% LEQ 5 (
echo Sorry, I can't work in Windows XP and lower...
pause
exit
)
wmic diskdrive get Index,Partitions,Model,Size,Caption
echo WARNING! All data on the drive you select will be deleted!
set /p IndexOfInstallDrive="Enter the INDEX of the disk on which the installation will be made: "
(
echo You have chosen drive %IndexOfInstallDrive%
Set /P drivepath=If this is wrong disk, enter the correct drive index now: || Set IndexOfInstallDrive=%IndexOfInstallDrive%
echo clean
echo create partition primary size=24
echo active
echo format fs=fat quick label=G2FM
echo assign
echo active
echo create partition primary
echo format fs=ntfs quick
echo assign
) > script.txt
echo Drive preparation...
diskpart /s script.txt>nul
del script.txt
echo Installing GRUB4DOS...
%cd%\grubinst.exe (hd%IndexOfInstallDrive%)
if %errorlevel%==0 (
SetLocal EnableDelayedExpansion
for /f "tokens=1* delims=" %%a in ('wmic LogicalDisk Get VolumeName^, Caption ^| findstr /i /c:"GRUBFM"') do (
for /f "tokens=1 delims=:" %%b in ("%%a") do (
echo Extracting files...
%cd%\7za.exe x -o%%b:\ -y %cd%\grubfm-bin.zip>nul
))
color 27
title G2FM Installer: success!
echo OK!
pause
exit /b
) else (
color 47
title G2FM Installer: error
echo RUNTIME ERROR!
pause
exit /b
)
