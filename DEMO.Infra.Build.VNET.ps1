function Build-RSVNET {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Location,

        [Parameter(Mandatory,
            HelpMessage = 'Enter the first two octets you want the subnet to have, e.g. 10.1')]
        [ValidatePattern('^[0-9]{1,3}\.[0-9]{1,3}$')]
        [string]$SubnetPrefix
    )

    $NetworkName = $ResourceGroupName + "_VNET"
    $SubnetName = $ResourceGroupName + "_Subnet"
    $SubnetAddress = $SubnetPrefix + '.0.0/24'
    $VirtualNetworkAddressPrefix = $SubnetPrefix + '.0.0/16'
    $Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddress
    $VirutalNetworkSplat = @{
        Name              = $NetworkName
        ResourceGroupName = $ResourceGroupName
        Location          = $Location
        AddressPrefix     = $VirtualNetworkAddressPrefix
        Subnet            = $Subnet
    }
    New-AzVirtualNetwork @VirutalNetworkSplat
    Write-Verbose "Created virtual network $NetworkName."
}