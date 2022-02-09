# code responsible for creating the virtual network in the DEMO resource group

# identify resource group and region
$ResourceGroupName = "DEMO"
$Location = "eastus2"

# construct virtual network
$NetworkName = "DEMO_VNET"
$SubnetName = "DEMO_Subnet"
$SubnetAddress = '192.168.0.0/24'
$VirtualNetworkAddressPrefix = '192.168.0.0/16'
$Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddress
$VirutalNetworkSplat = @{
    Name = $NetworkName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AddressPrefix = $VirtualNetworkAddressPrefix
    Subnet = $Subnet
}
New-AzVirtualNetwork @VirutalNetworkSplat
Write-Verbose "Created virtual network $NetworkName."