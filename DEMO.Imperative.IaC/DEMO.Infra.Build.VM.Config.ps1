# responsible for the configuration of the VMs - must be done from the Springboard computer peered and from ip 10.0.0.5
function Build-RSVMConfig {
    param (
        [Parameter(Mandatory)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory,
            HelpMessage = 'Enter the first two octets you want the subnet to have, e.g. 10.1')]
        [ValidatePattern('^[0-9]{1,3}\.[0-9]{1,3}$')]
        [string]$SubnetPrefix
    )

    $VMCount = (Get-AzVM -ResourceGroupName $ResourceGroupName).Count
    $Collection = @()

    for ($i = 0; $i -lt $VMCount; $i++) {
        $Octet = $i + 4
        $IPBuild = $SubnetPrefix + ".0." + $Octet
        $Collection += $IPBuild
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
}