# BeatDownloader 1.0.1
This utility allows you to  download all of the ranked custom levels that you don't currently have for Beat Saber.
<img src="https://i.imgur.com/fz0kwft.png" alt="BeatDownloader"/>
## Prerequisites
### ModAssistant
If you haven't used this before, make sure to run `ModAssistant.exe` and click the "Install or Update" button in the bottom right.

On the Options page, make sure the "BeatSaver" option is checked on the "Enable OneClick Installs" dropdown. This actually didn't work for me at first and I needed to uncheck "BeatSaver" and check it again before they were working as expected. I would recommend doing this just to be on the safe side.

Also on the Options page, change the "Show OneClick Installer Window" from the default "Yes" to "Close" or "No". Otherwise you will be left at the end with many open windows of the OneClick Installer.

Current release: https://github.com/Assistant/ModAssistant/releases/download/v1.1.13/ModAssistant.exe  
### BeatDownloader.bat
This can be used as-is if you have Beat Saber installed to the default Steam directory `C:\Program Files (x86)\Steam\steamapps\common\Beat Saber`. Otherwise replace the default file path on the first line in `BeatDownloader.bat`.
### Xidel
This is used for JSON parsing and only needs to be copied into the same folder that `BeatDownloader.bat` will run in. There is no installation needed for it.

Current release: https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.win32.zip  
## Downloading
With all that out of the way, just double-click `BeatDownloader.bat` and a dialog box will open to pick your Beat Saber install directory. Select your "Beat Saber" folder, click OK, and the command prompt window will display showing the current progress!

Note: As of writing there are currently 625 ranked custom levels, so this will take a while to complete. Closing the command prompt window will stop the process from running, but this can be restarted at a later time skipping the custom levels that have already been downloaded. The next time you start `BeatDownloader.bat`, your previously chosen directory will be automagically loaded. Deleting the generated `BeatPath.txt` will make the directory picker come up again if you have moved your Beat Saber install location.
## Credits
Beat Saver: https://beatsaver.com/  
Beat Savior: https://beat-savior.herokuapp.com/  
ModAssistant: https://github.com/Assistant/ModAssistant  
Xidel: https://github.com/benibela/xidel