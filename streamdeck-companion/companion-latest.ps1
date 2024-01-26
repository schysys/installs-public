# The Get-InstalledSoftwareVersion function checks if the software is installed and returns its version.
# The Install-Companion function contains the logic to download and install Companion. # Replace $url and $installerArguments with the actual download URL and necessary arguments.
# The script determines whether to install, update, or skip based on the presence of -u (update) or -s (skip) arguments and the current installation status.
# Implement the logic to determine the latest version of Companion where $latestVersion = "X.X.X" is mentioned. This might involve querying a software repository or checking a website.
# The script assumes that the installer for Companion can run silently with specified arguments (like /S). Update this part based on the actual installer's capabilities.

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

function Install-Companion {
    # Define the download URL and installer commands for Companion
    $url = "https://companion.download/latest"  # Replace with the actual download URL
    $installerArguments = "/S"  # Replace with actual installer arguments

    # Download and execute the installer
    $tempPath = "$env:TEMP\companion_installer.exe"
    Invoke-WebRequest -Uri $url -OutFile $tempPath
    Start-Process -FilePath $tempPath -ArgumentList $installerArguments -Wait
    Remove-Item $tempPath
}

$softwareName = "Companion"  # Replace with the actual software registry name
$currentVersion = Get-InstalledSoftwareVersion -SoftwareName $softwareName

if ($currentVersion -eq $null) {
    Write-Host "$softwareName is not installed. Installing..."
    Install-Companion
} else {
    Write-Host "$softwareName is already installed. Current version: $currentVersion"
    
    # Check for latest version - implement version check logic here
    $latestVersion = "X.X.X"  # Replace with logic to find the latest version

    if ($currentVersion -ne $latestVersion) {
        $response = 'U'
        if (-not $u -and -not $s) {
            $response = Read-Host "Update available. Press 'U' to update or 'S' to skip"
        }
        if ($response -eq 'U' -or $u) {
            Write-Host "Updating $softwareName..."
            Install-Companion
        } elseif ($response -eq 'S' -or $s) {
            Write-Host "Skipping update for $softwareName."
        }
    } else {
        Write-Host "$softwareName is up to date."
    }
}
