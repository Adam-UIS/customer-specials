# PowerShell script to deploy the product page to IIS
# Run this script as Administrator

param(
    [string]$SiteName = "OBE-Product-Page",
    [string]$Port = "8080",
    [string]$PhysicalPath = "c:\Workspace\obe-product-page"
)

# Import WebAdministration module
Import-Module WebAdministration

# Check if site already exists
if (Get-Website -Name $SiteName -ErrorAction SilentlyContinue) {
    Write-Host "Site '$SiteName' already exists. Removing it first..." -ForegroundColor Yellow
    Remove-Website -Name $SiteName
}

# Create new website
Write-Host "Creating new website '$SiteName'..." -ForegroundColor Green
New-Website -Name $SiteName -PhysicalPath $PhysicalPath -Port $Port

# Set permissions for IIS_IUSRS
Write-Host "Setting permissions..." -ForegroundColor Green
$acl = Get-Acl $PhysicalPath
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl -Path $PhysicalPath -AclObject $acl

# Start the website
Start-Website -Name $SiteName

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "Your website is now available at: http://localhost:$Port" -ForegroundColor Cyan
Write-Host "Physical path: $PhysicalPath" -ForegroundColor Cyan
