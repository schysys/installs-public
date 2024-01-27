Prompt - install or update base Software package: 

I need a PowerShell script to install or update the base software package/application listed below on Windows but also could be used to update an existing install. 
This script can be called directly, however it will be 
The script needs to:
1. check to see if the software is installed and if it is installed, what version the software is currently at. 
2. check the what latest version of the software is from source
3. If not installed, install the software to the version passed in as an argument -v or to the latest version if specifc version is not provided.  
4. If installed, and the version installed is earlier than either the latest or the version poassed in as an argument, prompt the user to (U) update or  (S) skip update for that package and keep the one installed. 
5. The script should also take in these options as arguments so that the   -s and -u arguments -v (version) can be passed in so that the script can be used in automations. also if there are any arguments the package requires also, ie: Y to continue, please include these.

github check: Some software packages especially on windows are difficult to maintian source control links or require additonal manual steps to download, for these pacakges, I typically host the binary in github. 
If installing a specific version the script should:  
1. check the parent folder in github for a folder called:
         \bin\version-number\someBinary.exe before attempting to retrieve from source.
     ie: python\bin\3.12.0\python-3.12.0-amd64.exe
2. If a package exists in the bin dir,  matching the version number passed as an argument -v, use this package, otherwise attempt to get from source.

Please add ample echo statements to give feedback to the user as to the progress and various functions called, completed and any errors for debugging purposes. 

application: python 

Below are the std colors for messages and common arguments. Note: This base script will be referenced as a dependency for an install of other applications and will be called externally from those scripts and chained together.  

<!-- 

std_color.ps1
function Write-ErrorLog {
    param([string]$message)
    Write-Host $message -ForegroundColor Red
}
function Write-WarningLog {
    param([string]$message)
    Write-Host $message -ForegroundColor Yellow
}
function Write-InfoLog {
    param([string]$message)
    Write-Host $message -ForegroundColor Green
}
function Write-Prompt {
    param([string]$message)
    Write-Host $message -ForegroundColor Cyan 
    
std_parameters.ps1
param(
    [switch]$s,  # Skip update
    [switch]$u,  # Update
    [switch]$y   # Auto-accept (Yes)
)

    
    
    -->

