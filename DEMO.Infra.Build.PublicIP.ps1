# define values for public IP address
$ResourceGroupName = "DEMO"
$Location = "eastus2"
$PublicIPName = 'DEMO_PublicIP'
$AllocationMethod = "static"

# create public IP
$PublicIPSplat = @{
    Name = $PublicIPName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AllocationMethod = $AllocationMethod
}

New-AzPublicIpAddress @PublicIPSplat