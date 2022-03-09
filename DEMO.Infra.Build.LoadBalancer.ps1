# define values for public IP address
$ResourceGroupName = "DEMO"
$Location = "eastus2"
$PublicIPName = 'DEMO_PublicIP'
$AllocationMethod = "dynamic"

# define values for load balancer
$LBName = "DEMO_LoadBalancer"

$PublicIPSplat = @{
    Name = $PublicIPName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AllocationMethod = $AllocationMethod
}

New-AzPublicIpAddress @PublicIPSplat

New-AzLoadBalancer -