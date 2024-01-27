# 1) Refer to PS_PROMPT-baseSoftwarePkg.md as a starting point in terms of prompting for base package install
# 2) Only put binaries in the bin folder which are not easily downloadable from the internet. Note: GitHub limit is 50MB per file & 2GB total per account so use wisely.
# 3) This repo is public so do not put any sensitive information in the repo or any licensed software.
$githubRepoBase = 'https://github.com/schysys/installs-public/tree/main/python/bin'

. 'https://github.com/schysys/installs-public/blob/f0e39570be498e66ea446e836f966f17a794e28e/std_parameters.ps1'
. 'https://github.com/schysys/installs-public/blob/f0e39570be498e66ea446e836f966f17a794e28e/std_color.ps1'
. 'https://github.com/schysys/installs-public/blob/f0e39570be498e66ea446e836f966f17a794e28e/std_log_format.ps1'

# Add your installation logic here

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
    try {
        $url = "https://www.python.org/downloads/"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing

        # Parse the response content to find the latest Python version
        # This is a basic example and might need adjustments based on the actual webpage structure
        $matches = [regex]::Matches($response.Content, 'Latest Python 3 Release - Python (\d+\.\d+\.\d+)')
        if ($matches.Count -gt 0) {
            $latestVersion = $matches[0].Groups[1].Value
            return $latestVersion
        } else {
            Write-Warning "Unable to find the latest Python version from the website."
        }
    } catch {
        Write-Error "Error occurred while fetching the latest Python version: $_"
    }

    return $null
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
