﻿Param(
	[parameter(Mandatory = $true)][string]$Version,
	[parameter(Mandatory = $true)][string]$Distribution
)
End {
	$BaseURL = 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/2/eclipse-cpp-neon-2-win32-x86_64.zip&r=1'

	$ArchiveFilename = "eclipse-$Distribution-$Version-win32-x86_64.zip"

	$EclipseDownloadPage = 'https://www.eclipse.org/downloads/download.php'
	$Parameters = @{
		file = "/technology/epp/downloads/release/neon/2/$ArchiveFilename"
		r = "1"
	}

	$ProjectRoot = Split-Path $PSScriptRoot
	$PackageFolder = Join-Path -Path $ProjectRoot -ChildPath packages

	Invoke-WebRequest -Uri $EclipseDownloadPage -Body $Parameters -Method Get -OutFile (Join-Path $PackageFolder $ArchiveFilename)
}
