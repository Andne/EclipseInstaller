Param(
	[parameter(Mandatory = $false)][string]$Version = $env:EclipseRelease,
	[parameter(Mandatory = $false)][string]$Distribution = $env:EclipseDistribution,
	[parameter(Mandatory = $false)][string]$Architecture = $env:Platform
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

	if (-not (Test-Path $PackageFolder)) {
		New-Item -Path $PackageFolder -ItemType Directory | Out-Null
	}

	Write-Host "Downloading $ZipFilename to $PackageFolder"
	Invoke-WebRequest -Uri $EclipseDownloadPage -Body $Parameters -Method Get -OutFile (Join-Path $PackageFolder $ZipFilename)
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
