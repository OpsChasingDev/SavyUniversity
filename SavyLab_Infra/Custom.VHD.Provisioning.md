# Setup Requirements for Integrated Azure Lab Environment

Sections described in this readme detail what is necessary in order to provision the "permanent" aspects of the integrated Azure Labs environment with code-defined VMs and infrastructure.  A portion of the infrastructure will be in place at all times as it will not incur costs and be more efficiently dealt with at a manual basis.  The rest of the infrastructure, including the VMs, public IPs, associations, custom image creation, and configuration of the VMs' guest operating system(s) will all be built with automation as these things will incur costs when spun up and also benefit from being able to have their setup replicated effortlessly.

## Configuring Ansible for WinRM on Windows Target Host

*The following describes the steps needed to set up a custom Windows VHD which both enables WinRM connectivity from public networks and is generatlized for use in Azure VM provisioning.*

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

## A Note On Making Labs

When creating SavyLabs to use this environment, the lab template must be provisioned with the below minimum configuration changes in order to make sure each replica created from the template will be able to make WinRM connections to the infrastructure VMs over HTTP using basic authentication:

- Run WinRM quickconfig
    ```PowerShell
    winrm quickconfig -force
    ```
- Set TrustedHosts value
    ```PowerShell
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force
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