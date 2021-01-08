@echo off
SetLocal EnableDelayedExpansion

where xidel 2>nul || echo "Xidel needs to be added to the current directory in order to continue" && goto :End
if exist "response.json" (
   echo A partial run has been detected && echo 1^) Continue the previous run && echo 2^) Start over
   choice /c 12 /m "Please select an option"
   if errorlevel 2 goto :Start
   if errorlevel 1 goto :Continue
)

:Start
curl -o response.json https://beat-savior.herokuapp.com/api/maps/ranked

:Continue
set startDir=%cd%
cd "%LocalAppData%\ModAssistant"
for /f "delims=" %%a in ('dir /S /B user.config') do set modSettings=%%a
cd %startDir%

xidel -s %modSettings% --xpath './/configuration/userSettings/ModAssistant.Properties.Settings/setting[@name="OCIWindow"]/value' > output.txt
for /f "tokens=*" %%b in (output.txt) do set ociWindow=%%b
if "!ociWindow!"=="Yes" echo It is recommended to change the "Show OneClick Installer Window" setting from Yes to Close or No to avoid multiple open installer window processes && echo Press Y to continue anyway . . . && choice /c y /n

xidel -s %modSettings% --xpath './/configuration/userSettings/ModAssistant.Properties.Settings/setting[@name="InstallFolder"]' > output.txt
for /f "tokens=*" %%b in (output.txt) do set beatSaberPath=%%b
echo Using path: !beatSaberPath!

xidel response.json --xpath ".//key" > output.txt
for /f %%c in ('Find "" /v /c ^< output.txt') do set total=%%c
set curr=0
for /f "tokens=*" %%d in (output.txt) do (
   if exist "!beatSaberPath!\Beat Saber_Data\CustomLevels\%%d (*" (
      echo "Skipping already saved custom level"
   ) else (
      echo "Saving new custom level: %%d"
      start beatsaver://%%d
      timeout 8 >nul
   )
   set /a "curr+=1"
   echo Completed: !curr! / %total%
)
del output.txt response.json
echo "Finished!"

:End
pause
