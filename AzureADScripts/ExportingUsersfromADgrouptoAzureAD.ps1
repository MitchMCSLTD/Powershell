#Powershell Script to export users from On prem AD group and add them to Azure AD group# 
#Created: By Nathan Mitchell# 
#Date: 13/05/2023#
#Version: V1.0#

$ADGroupNameInput = Read-Host "Please Enter Prem AD group Name"
$AADGroupNameInput = Read-Host "Please Enter Azure AD Group Name"

$users = Get-ADGroupMember -Identity $ADGroupNameInput |%{Get-ADUser $_.SamAccountName | select UserPrincipalName -ExpandProperty UserPrincipalName }

$AADGroupNameInput = "NEW_ GROUP NAME"

$userobjectids = Foreach ($user in $users) 
{
    Get-AzureADUser -ObjectId $user | Select-Object -ExpandProperty ObjectId
}

$groupobjectid = Get-AzureADGroup -SearchString $AADGroupNameInput | Select-Object -ExpandProperty ObjectId
    
foreach ($userobjectid in $userobjectids) 
{
    Add-AzureADGroupMember -ObjectId $groupobjectid -RefObjectId $userobjectid 
}
