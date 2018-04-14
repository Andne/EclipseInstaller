Param(
	[string]$Version = $env:EclipseRelease
)
End {
	$VersionParts = $Version.Split('.')

	$MajorMinor = Get-MajorMinorVersion -ReleaseName $VersionParts[0]
	
	if ($VersionParts.Count -ge 2) {
		$Point = $VersionParts[1]
	}
	else {
		$Point = '0'
	}

	if ($env:APPVEYOR_BUILD_NUMBER) {
		$Build = $env:APPVEYOR_BUILD_NUMBER
	}
	else {
		$Build = '0'
	}

	$FullVersion = "$MajorMinor.$Point.$Build"

	# Tell appveyor about the calculated version information
	Update-AppveyorBuild -Version $FullVersion

	# Create a file to be included in the setup projects
	Write-WixIncludeFile -FullVersion $FullVersion -ReleaseName ((Get-Culture).TextInfo.ToTitleCase($VersionParts[0]))
}
Begin {
	# Define the appveyor function in case we aren't actually running on appveyor
	if (-not $env:APPVEYOR) {
		function Update-AppveyorBuild {
			Param(
				[string]$Version
			)

			if ($Version) {
				Write-Host "Setting Appveyor Version to $Version"
			}
		}
	}

	function Get-MajorMinorVersion {
		Param(
			[string]$ReleaseName
		)

		switch ($ReleaseName.ToLower()) {
			'juno'   { Write-Output '4.2' }
			'kepler' { Write-Output '4.3' }
			'luna'   { Write-Output '4.4' }
			'mars'   { Write-Output '4.5' }
			'neon'   { Write-Output '4.6' }
			'oxygen' { Write-Output '4.7' }
		}
	}

	function Write-WixIncludeFile {
		Param(
			[parameter(Mandatory = $true)][string]$FullVersion,
			[parameter(Mandatory = $true)][string]$ReleaseName
		)

		$WXIVersionFile = Join-Path (Join-Path $PSScriptRoot include) version.wxi

		"<?xml version='1.0'?>" | Out-File -FilePath $WXIVersionFile -Force
		"<Include xmlns='http://schemas.microsoft.com/wix/2006/wi'>" | Out-File -FilePath $WXIVersionFile -Append
		"  <?define FullVersion = '$FullVersion' ?>" | Out-File -FilePath $WXIVersionFile -Append
		"  <?define EclipseRelease = '$ReleaseName' ?>" | Out-File -FilePath $WXIVersionFile -Append
		"</Include>" | Out-File -FilePath $WXIVersionFile -Append
	}
}