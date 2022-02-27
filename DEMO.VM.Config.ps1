<#
Script to run against all remote VMs once powershell remoting is enabled in order to configure the services hosted on the VMs
#>

$cred = Get-Credential

$VMCount = (Get-AzVM -ResourceGroupName "DEMO").Count
$Collection = @()

for ($i = 0; $i -lt $VMCount; $i++) {
    $Octet = $i + 4
    $Collection += "192.168.0.$Octet"
}

# install web services
Invoke-Command $Collection -Credential $cred {
    Install-WindowsFeature 'Web-Server' -Restart -IncludeManagementTools
}

# copy custom web image
$Session = New-PSSession -ComputerName 192.168.0.4 -Credential $cred
Copy-Item -Path 'C:\Root\hello.png' -ToSession $Session -Destination 'C:\inetpub\wwwroot\'