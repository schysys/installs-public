## Function to check if Python is installed and if not install python and Set PATH
## Install packages 
## Function to check if DDM and ddm version, is installed and if not install DDM from /bin
## Function to check if companion is installed  and ddm version, is installed and if not install DDM from /bin


# Function to get Python executable path
function Get-PythonExecutablePath {
    $pythonPath = Get-Command python.exe -ErrorAction SilentlyContinue
    if ($null -eq $pythonPath) {
        Write-Host "Python is not installed."
        return $null
    } else {
        Write-Host "Found Python at $($pythonPath.Source)"
        return $pythonPath.Source
    }
}

# Function to install Python and Python packages
function Install-PythonAndPackages {
    # Define Python Installation Path (change version number if needed)
    $pythonVersion = "3.10.0"
    $pythonInstaller = "python-$pythonVersion-amd64.exe"
    $pythonURL = "https://www.python.org/ftp/python/$pythonVersion/$pythonInstaller"
    $installPath = "C:\Python$pythonVersion"

    # Download Python Installer
    Invoke-WebRequest -Uri $pythonURL -OutFile $pythonInstaller

    # Install Python Silently and Add to Path
    Start-Process .\$pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 TargetDir=$installPath" -Wait

    # Remove Installer File
    Remove-Item .\$pythonInstaller

    # Get Python executable path
    $pythonExePath = Get-PythonExecutablePath
    if ($null -eq $pythonExePath) {
        Write-Host "Failed to locate Python executable."
        return
    }

    # Install Python packages using pip
    $packages = "pygetwindow", "pyautogui", "pydrive", "O365", "openai", "google-api-python-client", "google-auth-httplib2", "google-auth-oauthlib"
    foreach ($package in $packages) {
        & $pythonExePath -m pip install $package
    }

    # Verifying Installation
    & $pythonExePath --version
    & (Join-Path (Split-Path $pythonExePath) "Scripts\pip.exe") --version
}

# Main Script
if ($null -eq (Get-PythonExecutablePath)) {
    $userChoice = Read-Host "Do you want to install the latest stable release of Python and additional packages? (Y/N)"
    if ($userChoice -eq 'Y') {
        Install-PythonAndPackages
    } else {
        Write-Host "Python installation aborted."
    }
} else {
    Write-Host "Python is already installed."
}
