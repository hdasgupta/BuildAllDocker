@echo on
setlocal enabledelayedexpansion

set argCount=1

set ports=

for %%x in (%*) do Set /A argCount+=1

set argIndex=1

set toRemove= 

set currentDir=%cd%

set jarsFolder=!currentDir:%toRemove%=!\jars

set dockerFile=!jarsFolder:%toRemove%=!\Dockerfile

set envFile=!jarsFolder:%toRemove%=!\.env

set mainBatchFile=!jarsFolder:%toRemove%=!\main.bat

set startupShellFile=!jarsFolder:%toRemove%=!\startup.sh

set launchBatchFile=!jarsFolder:%toRemove%=!\launch.bat

echo # > "%dockerFile%"

echo ^@echo on> "%mainBatchFile%" 

echo # > "%envFile%"

echo ^@echo on> "%launchBatchFile%" 

if exist "!jarsFolder:%toRemove%=!" (rmdir /S /Q !jarsFolder:%toRemove%=!) else (echo done)

mkdir !jarsFolder:%toRemove%=!

echo FROM ubuntu >> "%dockerFile%" 
echo #  >> "%dockerFile%"
echo RUN apt update >> "%dockerFile%"
echo # >> "%dockerFile%"
echo RUN apt install -y openjdk-17-jre >> "%dockerFile%"
echo # >> "%dockerFile%"
 
 
set /p=echo Starting  <nul >>"%startupShellFile%" 

set ports=

:routine
set folder=%1  && shift /1

set tag=!folder:%toRemove%=!
goto :lowerCase
:doneLowerCase


set /a "port=%argIndex% * 100"

set portName=!tag:%toRemove%=!Port

set ports=%ports% -p !port:%toRemove%=!:!port:%toRemove%=!


set projectFolder=%currentDir%\%folder%

set projectMainBatchFileName=!tag:%toRemove%=!Main.bat

set projectMainBatchFile=!jarsFolder:%toRemove%=!\!projectMainBatchFileName:%toRemove%=!

set deleteDirCommad=if exist "!projectFolder:%toRemove%=!" (rmdir !projectFolder:%toRemove%=! /s /q) else (echo done)
set githubCommand=gh repo clone hdasgupta/!folder:%toRemove%=!
set copyMvnFiles=COPY mvnw !projectFolder:%toRemove%=!\mvnw ^&^& COPY mvnw.cmd !projectFolder:%toRemove%=!\mvnw.cmd ^&^& if exist '!projectFolder:%toRemove%=!\.mvn' ^( echo done ^) else ^( mkdir !projectFolder:%toRemove%=!\.mvn ^) ^&^& if exist '!projectFolder:%toRemove%=!\.mvn\wrapper' ^( echo done ^) else ^( mkdir !projectFolder:%toRemove%=!\.mvn\wrapper ^) ^&^& copy .\.mvn\wrapper\maven-wrapper.jar !projectFolder:%toRemove%=!\.mvn\wrapper\maven-wrapper.jar ^&^& copy .\.mvn\wrapper\maven-wrapper.properties !projectFolder:%toRemove%=!\.mvn\wrapper\maven-wrapper.properties
set cdCommand=cd %projectFolder%
set "mvnCommand=.\mvnw clean install"

set "copyJar=copy /b !projectFolder:%toRemove%=!\target\^^*.jar !jarsFolder:%toRemove%=!\!folder:%toRemove%=!.jar"

echo %copyJar%

echo !portName:%toRemove%=!=%port% >> "%envFile%"

echo COPY ./!folder:%toRemove%=!.jar . >> "%dockerFile%" 
echo # >> "%dockerFile%" 
echo EXPOSE $!portName:%toRemove%=! >> "%dockerFile%" 
echo # >> "%dockerFile%"

set /p= ^| java -jar -Dserver.port=%port% !folder:%toRemove%=!.jar   <nul  >>"%startupShellFile%" 

echo Cleaning up %folder%... && %deleteDirCommad% && cd %currentDir%
echo Fetching %folder% Repo from github... && %githubCommand%
echo Install Maven for %folder%... && %copyMvnFiles%

echo cd !projectFolder:%toRemove%=! ^&^& echo Executing Maven Build Command... ^&^& %mvnCommand% ^&^& %copyJar% ^&^& cd %jarsFolder% >> "%projectMainBatchFile%"

set /p=%projectMainBatchFileName% ^&^&  <nul >>"%mainBatchFile%" 


echo start http^://localhost^:!port:%toRemove% =! >> %launchBatchFile%

set /a "argIndex=%argIndex%+1"

if %argIndex% lss %argCount% (goto :routine) else (goto :outrotine)

:outrotine

echo COPY ./startup.sh . >> "%dockerFile%"
echo # >> "%dockerFile%"
echo ENTRYPOINT ./startup.sh >> "%dockerFile%"

set changeToJarsFolder=cd !jarsFolder:%toRemove%=!
set dockerBuildCommand=docker build -t apps:latest .
set dockerTagCommand=docker tag apps:latest hdasgupta/apps:latest
set dockerPushCommand=docker push hdasgupta/apps:latest
set dockerStopCommand=docker stop -t 10 apps
set dockerDropCommand=docker rm -f apps
set dockerCreateCommand=docker create %ports% --env-file .env --name apps hdasgupta/apps:latest
set dockerRunCommand=docker start  apps

%changeToJarsFolder%

set /p=%dockerBuildCommand% ^&^& %dockerTagCommand% ^&^&  <nul >> ".\main.bat"
set /p=%dockerPushCommand% ^&^& <nul >> ".\main.bat"
set /p=%dockerStopCommand% ^& %dockerDropCommand% ^& <nul >> ".\main.bat"
set /p=%dockerCreateCommand% ^&^& <nul >> ".\main.bat"
set /p=%dockerRunCommand% ^&^& <nul >> ".\main.bat"
set /p=TIMEOUT 300 ^&^& <nul >> ".\main.bat"
set /p=launch.bat ^&^& exit  <nul >> ".\main.bat"


main.bat

goto :EOF

:lowerCase

IF [%tag%]==[] (GOTO :doneLowerCase)
SET tag=%tag:A=a%
SET tag=%tag:B=b%
SET tag=%tag:C=c%
SET tag=%tag:D=d%
SET tag=%tag:E=e%
SET tag=%tag:F=f%
SET tag=%tag:G=g%
SET tag=%tag:H=h%
SET tag=%tag:I=i%
SET tag=%tag:J=j%
SET tag=%tag:K=k%
SET tag=%tag:L=l%
SET tag=%tag:M=m%
SET tag=%tag:N=n%
SET tag=%tag:O=o%
SET tag=%tag:P=p%
SET tag=%tag:Q=q%
SET tag=%tag:R=r%
SET tag=%tag:S=s%
SET tag=%tag:T=t%
SET tag=%tag:U=u%
SET tag=%tag:V=v%
SET tag=%tag:W=w%
SET tag=%tag:X=x%
SET tag=%tag:Y=y%
SET tag=%tag:Z=z%
SET tag=%tag:_=%
SET tag=%tag:-=%
SET tag=%tag:toRemove=%

echo %tag%%

goto :doneLowerCase


:EOF
