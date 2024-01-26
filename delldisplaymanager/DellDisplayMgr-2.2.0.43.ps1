# The Get-InstalledSoftwareVersion function retrieves the current version of Dell Display Manager if installed.
# The Install-DellDisplayManager function downloads and installs Dell Display Manager version 2.2.0.43 from the provided GitHub binary location.
# The script checks for the specific version (2.2.0.43) and prompts the user for an update or skip if the version differs.
# The -u and -s parameters allow for automated updates or skipping updates, respectively.
# Ensure the download URL and silent installation arguments ($installerArguments) are correct for Dell Display Manager 2.2.0.43.
# The script assumes the installer supports silent installation. If additional arguments are needed for silent installation or to accept license agreements, they should be added to $installerArguments.


param(
    [switch]$u,  # Update argument
    [switch]$s   # Skip update argument
)

function Get-InstalledSoftwareVersion {
    param(
        [string]$SoftwareName
    )
    $installedSoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
                                             HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
                                             Where-Object { $_.DisplayName -like "*$SoftwareName*" }
    if ($installedSoftware -ne $null) {
        return $installedSoftware.DisplayVersion
    }
    return $null
}

function Install-DellDisplayManager {
    # Define the binary location for Dell Display Manager 2.2.0.43
    $url = "https://github.com/schysys/winstalls-public/raw/c08bb20efb4aac48d352eb593015a7f85084d807/DellDisplayManager/2.2.0.43/ddmsetup.exe"
    $installerArguments = "/S"  # Silent installation arguments

    # Download and execute the installer
    $tempPath = "$env:TEMP\ddmsetup.exe"
    Invoke-WebRequest -Uri $url -OutFile $tempPath
    Start-Process -FilePath $tempPath -ArgumentList $installerArguments -Wait
    Remove-Item $tempPath
}

$softwareName = "Dell Display Manager"
$requiredVersion = "2.2.0.43"
$currentVersion = Get-InstalledSoftwareVersion -SoftwareName $softwareName

if ($currentVersion -eq $null) {
    Write-Host "$softwareName is not installed. Installing version $requiredVersion..."
    Install-DellDisplayManager
} elseif ($currentVersion -ne $requiredVersion) {
    Write-Host "$softwareName version $currentVersion is installed. Required version: $requiredVersion"
    $response = 'U'
    if (-not $u -and -not $s) {
        $response = Read-Host "Press 'U' to update or 'S' to skip"
    }
    if ($response -eq 'U' -or $u) {
        Write-Host "Updating $softwareName to version $requiredVersion..."
        Install-DellDisplayManager
    } elseif ($response -eq 'S' -or $s) {
        Write-Host "Skipping update for $softwareName."
    }
} else {
    Write-Host "$softwareName version $requiredVersion is already installed."
}
