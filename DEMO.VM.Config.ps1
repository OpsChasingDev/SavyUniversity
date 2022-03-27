<#
Script to run against all remote VMs once powershell remoting is enabled in order to configure the services hosted on the VMs
#>

$LocalAdmin = "RStapleton"
$LocalPass = ConvertTo-SecureString "SomethingB3tt3r!@#" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalAdmin,$LocalPass)

$VMCount = (Get-AzVM -ResourceGroupName "DEMO").Count
$Collection = @()

for ($i = 0; $i -lt $VMCount; $i++) {
    $Octet = $i + 4
    $Collection += "192.168.0.$Octet"
}

# install web services
Invoke-Command $Collection -Credential $Credential {
    Install-WindowsFeature 'Web-Server' -Restart -IncludeManagementTools
}

# copy custom web image
$Session = New-PSSession -ComputerName $Collection -Credential $Credential
foreach ($s in $Session) {
    Copy-Item -Path 'C:\Root\hello.png' -ToSession $s -Destination 'C:\inetpub\wwwroot\iisstart.png'
}