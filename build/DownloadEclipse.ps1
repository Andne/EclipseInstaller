Param(
	[parameter(Mandatory = $false)][string]$Version = $env:EclipseRelease,
	[parameter(Mandatory = $false)][string]$Distribution = $env:EclipseDistribution,
	[parameter(Mandatory = $false)][string]$Architecture
)
End {
	$EclipseDownloadPage = 'https://www.eclipse.org/downloads/download.php'

	if ($Architecture -eq 'x64') {
		$EclipseArchSuffix = '-x86_64'
	}
	else {
		$EclipseArchSuffix = ''
	}

	$VersionParts = $Version.Split('.')
	$ZipVersion = $VersionParts -join '-'
	$ZipDistribution = Get-ZipDistributionCode -Distribution $Distribution

	$ZipFilename = "eclipse-$ZipDistribution-$ZipVersion-win32$EclipseArchSuffix.zip"

	$Parameters = @{
		file = "/technology/epp/downloads/release/$($VersionParts[0])/$($VersionParts[1])/$ZipFilename"
		r = "1"
	}

	$ProjectRoot = Split-Path $PSScriptRoot
	$PackageFolder = Join-Path -Path $ProjectRoot -ChildPath packages
	$ExtractionFolder = Join-Path -Path $PackageFolder -ChildPath "Eclipse$($Distribution)_$($Architecture)"

	if (-not (Test-Path $PackageFolder)) {
		New-Item -Path $PackageFolder -ItemType Directory | Out-Null
	}
	elseif (Test-Path $PackageFolder) {
		Remove-Item -Recurse $ExtractionFolder
	}

	# Download eclipse from the webserver
	Write-Host "Downloading $ZipFilename to $PackageFolder"
	Invoke-WebRequest -Uri $EclipseDownloadPage -Body $Parameters -Method Get -OutFile (Join-Path $PackageFolder $ZipFilename)

	# Extract eclipse
	Write-Host "Extracting $ZipFilename to $ExtractionFolder"
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $PackageFolder $ZipFilename), $ExtractionFolder)
}
Begin {
	function Get-ZipDistributionCode {
		Param(
			[parameter(Mandatory = $true)][string]$Distribution
		)

		switch ($Distribution.ToUpper()) {
			'CDT' { Write-Output 'cpp' }
			'PDE' { Write-Output 'committers' }
		}
	}
}
