Param(
	[parameter(Mandatory = $true)][string]$Version = $env:EclipseRelease
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

	Update-AppveyorBuild -Version $FullVersion
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
		}
	}
}