@echo off
SetLocal EnableDelayedExpansion

if not exist "BeatPath.txt" (
   type nul > BeatPath.txt
)
set beatSaberPath = ""
for /f "tokens=*" %%a in (BeatPath.txt) do set beatSaberPath=%%a
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose your BeatSaber folder.',0,0).self.path""
if "%beatSaberPath%"=="" (
   for /f "usebackq delims=" %%b in (`powershell %psCommand%`) do set "beatSaberPath=%%b"
   echo|set /p ="!beatSaberPath!">BeatPath.txt
)
if [!beatSaberPath!]==[] (
   echo "A directory must be selected to continue"
   goto :End
)
echo Using path: !beatSaberPath!

curl -o response.json https://beat-savior.herokuapp.com/api/maps/ranked
echo Got list of maps
xidel response.json --xpath ".//key" > output.txt
echo Converted maps to keys to open in beatsaver://key url
echo Please choose a timeout number between download requests.
:settime
set /p time="Recommended between 4-10: "
if %time% leq 0 echo NUMBER TOO LOW&goto settime
for /f %%c in ('Find "" /v /c ^< output.txt') do set total=%%c
set curr=0
for /f "tokens=*" %%d in (output.txt) do (
   if exist "!beatSaberPath!\Beat Saber_Data\CustomLevels\%%d (*" (
      echo "Skipping already saved custom level"
   ) else (
      echo "Saving new custom level: %%d"
      start beatsaver://%%d
      timeout %time% >nul
   )
   set /a "curr+=1"
   echo Completed: !curr! / %total%
)
del output.txt response.json
echo "Finished!"

:End
pause
