$ResourceGroupName = "DEMO"
$Location = "eastus2"
$AllocationMethod = "dynamic"

$PublicIPSplat = @{
    Name = 'DEMO_PublicIP'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AllocationMethod = $AllocationMethod
}

New-AzPublicIpAddress @PublicIPSplat