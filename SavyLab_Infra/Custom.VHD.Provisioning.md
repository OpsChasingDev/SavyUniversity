# Preparing Custom VHD Image for Azure VM Provisioning

*The following describes the steps needed to create a custom Windows image which both enables WinRM connectivity from public networks and is generatlized for use in Azure VM provisioning.*

## Configuring Ansible for WinRM on Windows Target Host

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
   7. Configure the public-scope "Windows Remote Management (HTTP-In)" firewall rule to allow connections from Any IP address
      ```PowerShell
      Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress "Any"
      ```
   8. Ansible will now be able to run plays on the target windows host with the below config set in the inventory file:
      ```Bash
      [all:vars]
      ansible_user="username"
      ansible_password="password"
      ansible_port=5985
      ansible_connection=winrm
      ansible_winrm_scheme=http
      ansible_winrm_server_cert_validation=ignore
      ansible_winrm_kerberos_delegation=true
      ```


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