param(
    [string]$v,  # Version
    [switch]$s,  # Skip update
    [switch]$u,  # Update
    [switch]$y   # Auto-accept (Yes)
)

function Invoke-ScriptFromUrl {
    param([string]$url, [string]$arguments)
    $scriptContent = (Invoke-WebRequest $url -UseBasicParsing).Content
    if (-not [string]::IsNullOrWhiteSpace($scriptContent)) {
        Invoke-Expression "$scriptContent $arguments"
    }
}
