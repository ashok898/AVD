
Steps for FSLogix configuration: 
 
	1. Create Storage account 
	Go to Azure portal > storage accounts > create storage account  
                Name-storage account-name 
	2. Under storage account we need to create file share. 
file share name-create 
	3. Login to domain controller VM and download the AzFilesHybrid module(https://github.com/Azure-Samples/azure-files-samples/releases) 
	4. After downloading, please extract the file in locally. 
	5. add storage account to domain by running below PowerShell commands 
Example: (Please modify the below attributes based on your Subscription/RG name /storage account name) 
Install-Module -Name Az -AllowClobber 
cd C:\Users\azadmin\Downloads\AzFilesHybrid 
.\CopyToPSPath.ps1
Import-Module -Name AzFilesHybrid 
Connect-AzAccount 
Get-AzSubscription 
$subscriptionId = "subid" 
$resourceGroupName = "your resource group" 
$storageAccountName = "name" 
	6. Once you completed above steps, please verify the Storage account been added to domain or not. 
please use the below command to validate: 
Join-AzStorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -DomainAccountType "ComputerAccount" 
 
	7. Also, you can verify storage account has been added to Active Directory (Go to active directory->Domain controllers>). We can check in the azure portal also (Go to portal->storage account->File share>you can see it is showing as Identity-based access:configured. Once FSLogix is successfully configured you will find the below Screen shot. 
       

 
   8. Assign RBAC role to users 
To assign users the role:  
	• Select Access control (IAM) go to > Select + Add, then select Add role assignment from the drop-down menu > Select the role Storage File Data SMB Share Elevator role and Storage File Data SMB Share Reader and select Next > On the Members tab, select User, group, or service principal, then select +Select members. In the search bar, search for and select the security group that contains the users who will use Profile Container > Select Review + assign to complete the assignment 
    9. Set NTFS permissions 
Go to azure portal > Navigate storage account>Click on file share >Connect>click on storage key> copy the script of the key. 

 
After this you need to open PowerShell in admin mode, run the key script > After running  this  script your FSLogix storage account will be mounted. 
 
Run the following commands to set permissions In the commands below, replace <mounted-drive-letter> with the letter of the drive you used to map the drive and <DOMAIN\GroupName> with the domain and sAMAccountName of the Active Directory group that will require access to the share. You can also specify the user principal name (UPN) of a user 
 
icacls <mounted-drive-letter>: /grant "<DOMAIN\GroupName>:(M)" 
icacls <mounted-drive-letter>: /grant "Creator Owner:(OI)(CI)(IO)(M)" 
icacls <mounted-drive-letter>: /remove "Authenticated Users" 
icacls <mounted-drive-letter>: /remove "Builtin\Users" 
 
     Profile container configuration 
FSLogix : https://learn.microsoft.com/en-us/fslogix/how-to-install-fslogix#verify-product-installation-and-version 
Download FSLogix >open file > extract all files >Go to X64>release>FSLogix app setup( install and register). 
 
Sign in the to the virtual machine as a local administrator> Open run command and run gpedit.msc command> And follow below path 

 

1. Enabled=1 
2. VHD locations =**************(<share name> 
3. Size in MBS=50000 
Releases · Azure-Samples/azure-files-samples
This repository contains supporting code (PowerShell modules/scripts, ARM templates, etc.) for deploying, configuring, and using Azure Files. - Azure-Samples/azure-files-samples
 
Releases · Azure-Samples/azure-files-samples
This repository contains supporting code (PowerShell modules/scripts, ARM templates, etc.) for deploying, configuring, and using Azure Files. - Azure-Samples/azure-files-samples
 

https://github.com/Azure-Samples/azure-files-samples/releases




# Get all user profiles on the VM
$profiles = Get-WmiObject Win32_UserProfile | Where-Object {
    $_.LocalPath -like "C:\Users\*" -and $_.Special -eq $false
}
 
foreach ($profile in $profiles) {
    $userSID = $profile.SID
    $localPath = $profile.LocalPath
 
    # Look for FSLogix profile folder inside AppData\Local
    $fslogixPath = Join-Path -Path $localPath -ChildPath "AppData\Local\FSLogix"
 
    if (-not (Test-Path $fslogixPath)) {
        Write-Output " LOCAL PROFILE: $localPath"
        Write-Output "    SID: $userSID"
        Write-Output ""
    }
    else {
        Write-Output "FSLogix Profile: $localPath"
        Write-Output "    SID: $userSID"
        Write-Output ""
    }
}

