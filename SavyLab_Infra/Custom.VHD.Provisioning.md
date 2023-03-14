# Preparing Custom VHD Image for Azure VM Provisioning

*The following describes the steps needed to create a custom Windows image which both enables WinRM connectivity from public networks and is generatlized for use in Azure VM provisioning.*

## Steps

1. Create Hyper-V VM using Generation 1 and a single, fixed disk
2. Configure guest OS appropriately for allowing public connectivity for automated configuration tools
   1. Allow RDP using sconfig
   2. Open inbound ICMP traffic for ping replies
       ```PowerShell
       New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Direction Inbound -Protocol ICMPv4 -Action Allow
       ```
   3. Allow WinRM connections from public networks over http using basic auth
       ```PowerShell
       Enable-PSRemoting -SkipNetworkProfileCheck -Force;
       Set-Item -Path WSMan:\\localhost\\Service\\AllowUnencrypted -Value true;
       Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress Internet;
       Set-Item wsman:\\localhost\\Client\\TrustedHosts -Value * -Force
       ```
3. Add a wildcard to TrustedHosts for your provisioning controller machine.  While this is generally unsafe to do, it will ensure that any public IP provisioned for the VMs being built will be contactable from the system running the provisioning scripts over WinRM.
   ```PowerShell
   Set-Item wsman:\localhost\Client\TrustedHosts -Value *
   ```

## Alternative Steps for Public Key Auth

1. Create Hyper-V VM using Generation 1 and a single, fixed disk
2. Configure guest OS appropriately for allowing public connectivity for automated configuration tools
   1. Allow RDP using sconfig
   2. Open inbound ICMP traffic for ping replies
       ```PowerShell
       New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Direction Inbound -Protocol ICMPv4 -Action Allow
       ```
3. Configure guest OS appropriately so SSH connections can be made without credentials
   1. Install OpenSSH client
      ```PowerShell
      Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
      ```
   2. Generate a key pair on the controller machine that will run the provisioning/configuration automation
      ```Bash
      ssh-keygen -t rsa -b 2048
      ```
   3. Download and install SSH Server
      ```PowerShell
      Invoke-WebRequest https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.9.1.0p1-Beta/OpenSSH-Win64-v8.9.1.0.msi -OutFile $HOME\Downloads\OpenSSH-Win64-v8.9.1.0.msi -UseBasicParsing;
      msiexec /i $HOME\Downloads\OpenSSH-Win64-v8.9.1.0.msi
      ```
   4. Copy the contents of the public key to a new file called "C:\Windows\ProgramData\ssh\administrators_authorized_keys" in the image
   5. PowerShell can now be invoked on the remote computer using SSH as the carrier such as the below example from the help file of Invoke-Command:
      ```PowerShell
      # Example 21: Run a script file on multiple remote computers using SSH as a job
          $sshConnections =
          @{ HostName="WinServer1"; UserName="Domain\UserA"; KeyFilePath="C:\Users\UserA\id_rsa" },
          @{ HostName="UserB@LinuxServer5"; KeyFilePath="/Users/UserB/id_rsa" }
          $results = Invoke-Command -FilePath c:\Scripts\CollectEvents.ps1 -SSHConnection $sshConnections
      ```
      PowerShell commands can also be run by using SSH directly:
      ```Bash
      ssh savy@13.92.121.68 'PowerShell "Get-Host"'
      ```

## Alternative Steps for Configuring Ansible for WinRM on Windows Target Host

1. Create Hyper-V VM using Generation 1 and a single, fixed disk
2. Configure guest OS appropriately for allowing public connectivity for automated configuration tools
   1. Allow RDP using sconfig
   2. Open inbound ICMP traffic for ping replies
       ```PowerShell
       New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Direction Inbound -Protocol ICMPv4 -Action Allow
       ```
   3. Set the default TLS version to 1.2
      ```PowerShell
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      ```
   4. Run WinRM setup
      ```PowerShell
      winrm quickconfig -force
      ```
   5. Enable basic auth to WinRM
      ```PowerShell
      Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value True
      ```
   6. Allow unencrypted traffic (using http)
      ```PowerShell
      Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value True
      ```
   7. 


## References
- [Preparing Image for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image)
- [Uploading Image to  Azure](https://docs.microsoft.com/en-us/previous-versions/azure/virtual-machines/windows/sa-upload-generalized)
- [Creating Managed Image from Upload](https://www.c-sharpcorner.com/article/creating-an-azure-vm-from-the-vhdxvhd-file/)
- [Video](https://www.youtube.com/watch?v=_b5T-dPpd00)
- [WinRM on Workgroup](https://woshub.com/using-psremoting-winrm-non-domain-workgroup/)
- [OpenSSH Server on Windows](https://woshub.com/connect-to-windows-via-ssh/)
- [Public Key Auth on Windows](https://woshub.com/using-ssh-key-based-authentication-on-windows/)
- [Ansible Docs WinRM on Windows](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#setup-winrm-listener)
- [Video](https://www.youtube.com/watch?v=aPN18jLRkJI)