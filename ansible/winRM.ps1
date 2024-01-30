# PowerShell script to enable WinRM and configure firewall rules

# Enable WinRM service
# This command starts the WinRM service and sets it to start automatically with the system
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Configure WinRM listener
# This creates a listener for HTTP and HTTPS (if an SSL certificate is available)
winrm quickconfig -q
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Open firewall for WinRM HTTP (default port 5985)
# If you're using HTTPS, also open port 5986
New-NetFirewallRule -DisplayName "WinRM HTTP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985 -Enabled True

# If using HTTPS, uncomment the line below to open firewall for WinRM HTTPS (default port 5986)
# New-NetFirewallRule -DisplayName "WinRM HTTPS" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986 -Enabled True

Write-Host "WinRM has been configured and firewall rules are set."
