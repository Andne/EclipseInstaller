Param(
	[parameter(Mandatory = $true)][string]$Version,
	[parameter(Mandatory = $true)][string]$Distribution,
	[parameter(Mandatory = $false)][string]$Architecture = 'x64'
)
End {
	$EclipseDownloadPage = 'https://www.eclipse.org/downloads/download.php'

	if ($Architecture -eq 'x64') {
		$EclipseArchSuffix = '-x86_64'
	}
	else {
		$EclipseArchSuffix = ''
	}

	$ArchiveFilename = "eclipse-$Distribution-$Version-win32$EclipseArchSuffix.zip"

	$Parameters = @{
		file = "/technology/epp/downloads/release/neon/2/$ArchiveFilename"
		r = "1"
	}

	$ProjectRoot = Split-Path $PSScriptRoot
	$PackageFolder = Join-Path -Path $ProjectRoot -ChildPath packages

	if (-not (Test-Path $PackageFolder)) {
		New-Item -Path $PackageFolder -ItemType Directory | Out-Null
	}

	Invoke-WebRequest -Uri $EclipseDownloadPage -Body $Parameters -Method Get -OutFile (Join-Path $PackageFolder $ArchiveFilename)
}
