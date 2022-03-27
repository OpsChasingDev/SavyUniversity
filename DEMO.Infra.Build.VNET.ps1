function Build-RSVNET {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Location
    )

    $NetworkName = $ResourceGroupName + "_VNET"
    $SubnetName = $ResourceGroupName + "_Subnet"
    $SubnetAddress = '192.168.0.0/24'
    $VirtualNetworkAddressPrefix = '192.168.0.0/16'
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