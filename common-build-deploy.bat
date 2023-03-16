@echo on
setlocal enabledelayedexpansion

set argCount=0

set ports=

for %%x in (%*) do Set /A argCount+=1

set argIndex=2 

set toRemove= 

set outPort=

set folder=%1 && shift /1

set tag=!folder:%toRemove%=!

:lowerCase

IF [%tag%]==[] (GOTO :routine)
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
SET tag=%tag: =%

echo %tag%%

:routine
	set sourcePort=%1  && shift /1
  	set hostPort=%1  && shift /1
	set ports=%ports% -p !hostPort:%toRemove% =!:!sourcePort:%toRemove% =!
	
	set /a "argIndex=%argIndex%+2"

	if %sourcePort% == 80 (set outPort=%hostPort%)
	if %sourcePort% == 8080 (set outPort=%hostPort%)

	if %argIndex% lss %argCount% (goto :routine) else (goto :outrotine)

:outrotine

set deleteDirCommad=if exist ".\!folder:%toRemove%=!" (rmdir .\!folder:%toRemove%=! /s /q) else (echo done)
set githubCommand=gh repo clone hdasgupta/!folder:%toRemove%=!
set "copyMvnFiles=COPY mvnw .\!folder:%toRemove%=!\mvnw && COPY mvnw.cmd .\!folder:%toRemove%=!\mvnw.cmd && mkdir .\!folder:%toRemove%=!\.mvn && mkdir .\!folder:%toRemove%=!\.mvn\wrapper && copy .\.mvn\wrapper\maven-wrapper.jar .\!folder:%toRemove%=!\.mvn\wrapper\maven-wrapper.jar && copy .\.mvn\wrapper\maven-wrapper.properties .\!folder:%toRemove%=!\.mvn\wrapper\maven-wrapper.properties"
set cdCommand=cd %folder%
set mvnCommand=.\mvnw clean install
set dockerBuildCommand=docker build -t !tag:%toRemove% =!:latest .
set dockerPushCommand=docker push !tag:%toRemove% =!:latest
set dockerStopCommand=docker stop -t 10 !tag:%toRemove% =!
set dockerDropCommand=docker rm -f !tag:%toRemove% =!
set dockerCreateCommand=docker create!ports:%toRemove% =! --name !tag:%toRemove% =! !tag:%toRemove% =!:latest
set dockerRunCommand=docker start !tag:%toRemove% =!
set appURL=http://localhost:!outPort:%toRemove% =!

echo Cleaning up... && %deleteDirCommad%

echo Fetching Repo from github... && %githubCommand% && ^
echo Install Maven... && %copyMvnFiles% && ^
echo Change Directory... && %cdCommand% && ^
echo Executing Maven Build Command... && %mvnCommand% && ^
echo Executing Docker Image Build Command... && %dockerBuildCommand% && ^
echo Pushing Docker Image DockerHub... && %dockerPushCommand% && ^
echo Deleting Container (If Exists) && %dockerStopCommand% & %dockerDropCommand% & ^
echo Executing Docker Component Create Command... && %dockerCreateCommand% && ^
echo Executing Docker Container Run Command && %dockerRunCommand% && ^
echo Docker Component Created Successfully. && TIMEOUT 30 && ^
echo Opening %appURL%... && start %appURL% && exit

