@echo off
setlocal 
%~d0
cd "%~dp0"

echo.
echo ========= Running Pre-Deployment Script... =========
powershell.exe -ExecutionPolicy Unrestricted -NonInteractive -command "%~dp0preDeployWAz ..\..\..\code\SocialGames.Web  ..\..\..\code\SocialGames.Cloud\ServiceConfiguration.Cloud.cscfg"
echo =========   Pre-Deployment Script done!    =========
