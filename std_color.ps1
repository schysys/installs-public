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
}
