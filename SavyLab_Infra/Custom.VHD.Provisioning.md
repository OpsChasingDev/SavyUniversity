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

## References
- [Preparing Image for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image)
- [Uploading Image to  Azure](https://docs.microsoft.com/en-us/previous-versions/azure/virtual-machines/windows/sa-upload-generalized)
- [Creating Managed Image from Upload](https://www.c-sharpcorner.com/article/creating-an-azure-vm-from-the-vhdxvhd-file/)
- [Video](https://www.youtube.com/watch?v=_b5T-dPpd00)
- [WinRM on Workgroup](https://woshub.com/using-psremoting-winrm-non-domain-workgroup/)