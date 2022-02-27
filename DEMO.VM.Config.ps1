<#
Script to run against all remote VMs once powershell remoting is enabled in order to configure the services hosted on the VMs
#>

$VMCount = (Get-AzVM -ResourceGroupName "DEMO").Count
$Collection = @()

for ($i = 0; $i -lt $VMCount; $i++) {
    $Octet = $i + 4
    $Collection += "192.168.0.$Octet"
}

Write-Output $Collection

# install web services

Invoke-Command $Collection -Credential $cred {
    Install-WindowsFeature web-server -Restart -IncludeManagementTools
}
