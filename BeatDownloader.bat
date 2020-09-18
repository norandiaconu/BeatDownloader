set beatSaberPath="C:\Program Files (x86)\Steam\steamapps\common\Beat Saber"

@echo off
setlocal EnableDelayedExpansion
curl -o response.json https://beat-savior.herokuapp.com/api/maps/ranked
xidel response.json --xpath ".//maps/Key" > output.txt
for /f %%a in ('Find "" /v /c ^< output.txt') do set total=%%a
set curr=0
for /f "tokens=*" %%b in (output.txt) do (
   if exist "!beatSaberPath!\Beat Saber_Data\CustomLevels\%%b (*" (
      echo "Skipping already saved custom level"
   ) else (
      echo "Saving new custom level: %%b"
      start beatsaver://%%b
      timeout 10 >nul
   )
   set /a "curr+=1"
   echo Completed: !curr! / %total%
)
del output.txt response.json
echo "Finished!"
pause