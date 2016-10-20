# autoUnrarTV
This script will unrar/copy tv shows to a specified directory based on the file name.

BEFORE STARTING:
install winrar (http://www.rarlab.com/download.htm), trial version is okay as we are not using the GUI and only using unrar.exe 
Make note of the isnstall location of the "unrar.exe" as it's needed for line 9
Edit unrarTV.ps1 file using your favorite text editor and update lines 3,5,7,9 with the paths that are unique to your system.

unrarTV.ps1 uses tv.ps1 as the guide to which show goes where, I have uploaded a sample tv.ps1 file. 

tv.ps1 uses the rarfile name not the folder name to determine the location, for expamle if the rarfile ->
name is "the.janitor.802.720p-dimension.rar" but it's really the show "The Middle" then the line in tv.csv ->
must be "the.janitor,W:\The Middle"

