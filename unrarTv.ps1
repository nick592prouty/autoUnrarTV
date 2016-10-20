
#$downloadLocation - is where all your raw (.rar/.mkv/.mp4/.avi ...ect) files are located- THIS DIRECTORY SHOULD ONLY HAVE TV SHOWS, NO MOVIES!!!!!!!!!!!!!
$downloadLocation = "X:\Tv Shows\"
#$regexfile - is where the .csv file is located that has the string of the file name and it's final destination 
$regexfile = Import-Csv S:\tv.csv
#$defaultUnrarPath - is where tv shows will be unrar if it's not listed in $regexfile
$defaultUnrarPath = "W:\unrar"
#$unrarExePath - is the path where you have installed winrar (http://www.rarlab.com/download.htm) the trial in fine as we are not using the GUI only the unrar.exe
$unrarExePath = "C:\Program Files (x86)\WinRAR\unrar.exe" #MAKE SURE TO HAVE THE FULL PATH


#Start of script
$fileTounrar = (Get-ChildItem -recurse -Path $downloadLocation | where {$_.extension -match "mkv" -or $_.extension -match "mp4" -or $_.extension -match "avi" -or $_.extension -match "nfo" -or $_.extension -match "idx" -or $_.extension -match "rar" -or $_.extension -match "srt"})

foreach($file in $fileTounrar){
$fileType = "NA"
$fileName = "Blank"
$fullFolderPath = $file | select -expand VersionInfo | select -expand Filename
write-host "full folder path $fullFolderPath"
#need to know if I need to unrar or copy the file
if($fullFolderPath -match "rar"){
	$fileType = "rar"
}
if($fullFolderPath -match "mkv" -or $fullFolderPath -match "mp4" -or $fullFolderPath -match "avi" -or $fullFolderPath -match "idx" -or $fullFolderPath -match "srt"){
	$fileType = "mkv"
}
#becuase fuck samples
if($fullFolderPath -match "sample"){
	$fileType = "sample"
}
write-host "fileType: $fileType"
#determining the file name so I can check if it already exist, if it already exist I don't copy it. Our drives have enough work already
	if($fileType -eq "rar"){
		try{
			$fileName = C:\"Program Files (x86)"\WinRAR\unrar.exe l $fullFolderPath 
			$fileName = $fileName[7]
			$fileName = $fileName.Split(" ")[1]
		}catch{
			write-host "Is the file $fileName done downloading ?"
		}
	}elseif($fileType -eq "mkv"){
		$fileName = $file 
	}
	write-host "filename is $fileName"
$exist = "False"
	foreach($regex in $regexfile){
		$regexFilter = $regex.name
		$regexPath = $defaultUnrarPath
		$regexPath = $regex.Path
			if( $filename -match $regexFilter){
				$fullpath = $regexPath + "\" + $fileName
				write-host "regex fileter : $regexFilter"
				write-host "full path : $fullpath"
				$exist = test-path $fullpath
				write-host "does the full path exist ? : $exist"
				if(!$exist){
						if($fileType -eq "rar"){
							try{
							$folderExist = test-path $regexPath 
							write-host "Folder $regexPath : $folderExist" -foregroundcolor "red"
								if(!$folderExist){
									write-host "I am making the following path $regexPath" -foregroundcolor "blue"
									New-Item $regexPath -type directory
								}
							write-host "unraring : $fullFolderPath to $regexPath"
							invoke-command	$unrarExePath e -r -o- -y $fullFolderPath $regexPath 
							}catch{
									write-host "There was an error unraring $fullFolderPath"
							}
						}elseif($fileType -eq "mkv"){
							write-host "mkv file $mkvFile"
							#The below line checks to see if lftp (https://lftp.yar.ru/) has finished downloading the file, if it has then it processes it.
							$partialDownload = $fullFolderPath + ".lftp-pget-status"
							write-host "partial download $partialDownload"
							$partialExist = test-path $partialDownload
							write-host "partial exist $partialExist"
							if(!$partialExist){
								write-host " I copied $fullFolderPath to $regexPath"
								$folderExist = test-path $regexPath 
								write-host "Folder $regexPath : $folderExist" -foregroundcolor "red"
								if(!$folderExist){
									write-host "I am making the following path $regexPath" -foregroundcolor "blue"
									New-Item $regexPath -type directory
								}
								copy-item $fullFolderPath  $regexPath  -force 	
							}else{
								write-host " $mkvFile has not been unrared and is not done downloading"
							}
						}
					}			
				}
			}	
	}

