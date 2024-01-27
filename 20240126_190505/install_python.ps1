# Version Checking: The script checks the installed version of Python and compares it with the specified or latest version.
# GitHub Binary Check: Before downloading from the official source, the script attempts to fetch the installer from the specified GitHub repository.
# Install or Update Logic: Based on the comparison of versions, it decides whether to install or update Python.
# Command-line Arguments: Accepts -v for specifying a version, -u to update, and -s to skip updating.
# Feedback and Error Handling: Includes Write-Host statements for user feedback and basic error handling for download failures.
# Note:
# Replace the Get-LatestPythonVersion function's return value with actual logic to determine the latest Python version.
# Ensure the GitHub repository URL and path structure ($githubRepoBase) matches your actual repository.
# This script assumes the Python installer supports silent installation with the specified arguments.



param(
    [string]$v,  # Specific version argument
    [switch]$u,  # Update argument
    [switch]$s   # Skip update argument
)

$githubRepoBase = "https://github.com/schysys/installs-public/tree/main/python/bin"

function Get-InstalledSoftwareVersion {
    try {
        $pythonVersion = & python --version 2>&1
        if ($pythonVersion -like "Python*") {
            return $pythonVersion.Replace("Python ", "").Trim()
        }
    } catch {
        Write-Host "Python is not installed."
    }
    return $null
}

function Get-LatestPythonVersion {
    # Logic to determine the latest Python version from the official source
    # Placeholder for actual implementation
    return "3.12.0" # Example latest version
}

function Install-Python {
    param(
        [string]$version
    )

    $binPath = "$githubRepoBase/$version/python-$version-amd64.exe"
    $installerPath = "$env:TEMP\python-$version-installer.exe"

    if (Invoke-WebRequest -Uri $binPath -OutFile $installerPath -UseBasicParsing -ErrorAction SilentlyContinue) {
        Write-Host "Downloading Python $version from GitHub..."
    } else {
        # Fallback to official source if not found in GitHub repo
        $officialSource = "https://www.python.org/ftp/python/$version/python-$version-amd64.exe"
        Invoke-WebRequest -Uri $officialSource -OutFile $installerPath -UseBasicParsing
        Write-Host "Downloading Python $version from the official source..."
    }

    Write-Host "Installing Python $version..."
    Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item $installerPath
}

$currentVersion = Get-InstalledSoftwareVersion
$requiredVersion = if ($v) { $v } else { Get-LatestPythonVersion }

if ($null -eq $currentVersion) {
    Write-Host "Python is not installed. Proceeding with installation..."
    Install-Python -version $requiredVersion
} elseif ($currentVersion -ne $requiredVersion) {
    $response = if ($u) { 'U' } elseif ($s) { 'S' } else { Read-Host "Python $currentVersion is installed. New version $requiredVersion is available. Press 'U' to update or 'S' to skip" }
    
    if ($response -eq 'U') {
        Write-Host "Updating Python to version $requiredVersion..."
        Install-Python -version $requiredVersion
    } else {
        Write-Host "Update skipped. Keeping Python version $currentVersion."
    }
} else {
    Write-Host "Python version $requiredVersion is already installed."
}
