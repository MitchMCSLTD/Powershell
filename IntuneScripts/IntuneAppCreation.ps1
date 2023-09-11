#Package MSI as .intunewin file
$SourceFolder = "C:\Win32Apps\Source\7-Zip"
$SetupFile = "7z1900-x64.msi"
$OutputFolder = "C:\Win32Apps\Output"
$Win32AppPackage = New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $OutputFolder -Verbose

# Get MSI meta data from .intunewin file
$IntuneWinFile = $Win32AppPackage.Path
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
$Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"  
  
# Create MSI detection rule
$DetectionRule = New-IntuneWin32AppDetectionRuleMSI -ProductCode $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductCode -ProductVersionOperator "greaterThanOrEqual" -ProductVersion $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion

# Convert image file to icon
$ImageFile = "C:\Win32Apps\Logos\7-Zip.png"
$Icon = New-IntuneWin32AppIcon -FilePath $ImageFile

# Add new MSI Win32 app
$Win32App = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "Install 7-zip application" -Publisher $Publisher -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -ReturnCode $ReturnCode -Icon $Icon -Verbose

# Add assignment for all users
Add-IntuneWin32AppAssignmentAllUsers -ID $Win32App.id -Intent "available" -Notification "showAll" -Verbose