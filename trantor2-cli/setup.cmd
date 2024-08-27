@echo off

set "TRANTOR2_HOME=%~dp0"

setx TRANTOR2_HOME %~dp0

For /F "Skip=2Tokens=1-2*" %%A In ('Reg Query HKCU\Environment /V PATH 2^>Nul') Do set CURRENT_USER_PATH=%%C

set "TRANTOR_PATH=%%TRANTOR2_HOME%%bin"

echo %CURRENT_USER_PATH%|find "%TRANTOR_PATH%" >nul
if "%errorlevel%"=="1" (setx PATH "%CURRENT_USER_PATH%;%TRANTOR_PATH%")

docker-machine ip
if not "%errorlevel%"=="0" goto errorDockerIp

For /F "usebackq Tokens=*" %%A In (`docker-machine ip`) Do set DOCKER_HOST_IP=%%A

(echo. & echo # trantor local host & echo. & echo %DOCKER_HOST_IP% trantor2.terminus.io) >> %WINDIR%\System32\Drivers\Etc\Hosts

echo "Setup trantor environment success"

pause
exit

:errorDockerIp
echo get docker machine ip error
pause
