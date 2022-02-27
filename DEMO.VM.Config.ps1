<#
Script to run against all remote VMs once powershell remoting is enabled in order to configure the services hosted on the VMs
#>

$VMCount = (Get-AzVM -ResourceGroupName "DEMO").Count


# install web services
Invoke-Command $demo -Credential $cred {
    Install-WindowsFeature web-server -Restart -IncludeManagementTools
}