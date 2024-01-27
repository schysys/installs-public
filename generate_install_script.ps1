# When you need a new install script, just run .\generate_install_software-package.ps1 -newPackageName "somePackageName".

# A. checks to see if folder 'somePackageName' already exists, if not creates it. If it does prompt the user to change name or overwrite.
# B. if overwrite,  it renames existing folder appended with somePackageName_bkp_date_time   
# within the folder 'somePackageName' it create another folder called bin
# also within the folder go it create a file called install_somePackageName.ps1 (in this example)
# C. it add's the following comment at the top of the file "1) Refer to PS_PROMPT-baseSoftwarePkg.md as a starting point in terms of promting for base package install"
# "2) only put binaries in the bin folder which are not easily downloadable from the internet. Note: github limit is 50mb per file & @GB total per acount so use wisely."
# 3) this repo is public so do not put any sensitive information in the repo or any licensed software
# " the tmeplate conent at the top 
# D. add template content after comment so that every file points to the same std_parameters.ps1, std_color.ps1, std_log_format.ps1

param(
    [string]$newPackageName
)

function CreateInstallScript {
    param(
        [string]$packageName
    )

    $packagePath = ".\$packageName"

    # Check if package directory exists
    if (Test-Path -Path $packagePath) {
        $userChoice = Read-Host "Folder '$packageName' already exists. Overwrite? (Y/N)"
        if ($userChoice -eq 'Y') {
            $backupName = "$packageName`_bkp_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            $backupPath = Join-Path -Path (Get-Location) -ChildPath $backupName
            Rename-Item -Path $packagePath -NewName $backupPath
            Write-Host "Existing folder renamed to $backupName"
        } else {
            return
        }
    }

    # Create new package and bin directories
    New-Item -ItemType Directory -Path $packagePath -Force
    $binPath = Join-Path -Path $packagePath -ChildPath "bin"
    New-Item -ItemType Directory -Path $binPath -Force

    # Define the path of the new script file
    $scriptPath = Join-Path -Path $packagePath -ChildPath "install_$packageName.ps1"

    # Add comments and template content
    $comments = @"
# 1) Refer to PS_PROMPT-baseSoftwarePkg.md as a starting point in terms of prompting for base package install
# 2) Only put binaries in the bin folder which are not easily downloadable from the internet. Note: GitHub limit is 50MB per file & 2GB total per account so use wisely.
# 3) This repo is public so do not put any sensitive information in the repo or any licensed software.

"@  # Closing quote for the here-string

    $githubRepoBase = "https://github.com/schysys/installs-public/tree/main/$packageName/bin"

    # Updated template content to use Invoke-ScriptFromUrl
    $templateContent = @"
function Invoke-ScriptFromUrl {
    param(
        [string]`$url
    )
    `$scriptContent = (Invoke-WebRequest `$url -UseBasicParsing).Content
    if (-not [string]::IsNullOrWhiteSpace(`$scriptContent)) {
        Invoke-Expression `$scriptContent
    }
}

`$githubRepoBase = '$githubRepoBase'

Invoke-ScriptFromUrl -url 'https://raw.githubusercontent.com/schysys/installs-public/f0e39570be498e66ea446e836f966f17a794e28e/std_parameters.ps1'
Invoke-ScriptFromUrl -url 'https://raw.githubusercontent.com/schysys/installs-public/f0e39570be498e66ea446e836f966f17a794e28e/std_color.ps1'
Invoke-ScriptFromUrl -url 'https://raw.githubusercontent.com/schysys/installs-public/f0e39570be498e66ea446e836f966f17a794e28e/std_log_format.ps1'

# Add your installation logic here
"@

    # Write comments and template content to the new script file
    $fullContent = $comments + $templateContent
    $fullContent | Out-File -FilePath $scriptPath -Force
    Write-Host "New script created at $scriptPath"
}

CreateInstallScript -packageName $newPackageName
