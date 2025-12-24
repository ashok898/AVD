
 enable RDP access to a Windows VM using Azure Run Command, you can run a PowerShell script that:
	1. Enables the RDP service.
	2. Allows RDP through the Windows Firewall.
	3. Ensures the VM is listening on port 3389.

🛠 Steps to Enable RDP via Azure Run Command
1. Go to Azure Portal
	• Navigate to Virtual Machines.
	• Select the VM you can't RDP into.
	• Go to Operations > Run command.
	• Choose RunPowerShellScript.

2. Paste and Run This Script
 
Plain Text
# Enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Enable RDP through Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Restart RDP service (optional but helpful)
Restart-Service -Name TermService -Force

# Confirm RDP port is listening
Get-NetTCPConnection -LocalPort 3389
 

3. Check NSG and Azure Firewall (if applicable)
Make sure:
	• Port 3389 is allowed in the Network Security Group (NSG) attached to the VM's NIC or subnet.
	• If you're using Azure Firewall or a third-party NVA, allow outbound/inbound rules for RDP.



To restart the Remote Desktop (RDP) service on a Windows VM using Azure Run Command, follow these steps:

✅ Steps to Restart RDP Service via Azure Run Command
1. Go to Azure Portal
	• Navigate to Virtual Machines.
	• Select your Windows VM.
	• In the left menu, go to:     Operations > Run command
	• Click on RunPowerShellScript.

2. Paste This PowerShell Script
 
Plain Text
# Restart the Remote Desktop Services (TermService)
Restart-Service -Name TermService -Force

# Confirm the service is running
Get-Service -Name TermService
 
This will:
	• Forcefully restart the Remote Desktop Services.
	• Show the current status of the service (should be Running).

🧪 Optional: Check if RDP Port is Listening
You can also add this line to verify that port 3389 is open:
 

Yes, you can enable RDP (port 3389) on a Windows VM by modifying the Windows Registry using Azure Run Command. Here's how to do it:

🛠 Enable RDP Port 3389 via Registry Using Run Command
1. Go to Azure Portal
	• Navigate to your Windows VM.
	• Go to: Operations > Run command > RunPowerShellScript

2. Paste This PowerShell Script

# Enable RDP connections via registry
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
# Ensure RDP port is set to 3389
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "PortNumber" -Value 3389
# Enable RDP firewall rule
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Restart RDP service
Restart-Service -Name TermService -Force
# Confirm port 3389 is listening
Get-NetTCPConnection -LocalPort 3389


🔍 What This Script Does
	• Enables RDP by setting fDenyTSConnections to 0.
	• Ensures port 3389 is configured in the registry.
	• Enables firewall rules for RDP.
	• Restarts the RDP service to apply changes.
	• Checks if port 3389 is listening.

