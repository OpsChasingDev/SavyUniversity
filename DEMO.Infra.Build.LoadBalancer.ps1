# define values for public IP address
$ResourceGroupName = "DEMO"
$Location = "eastus2"
$PublicIPName = 'DEMO_PublicIP'
$AllocationMethod = "dynamic"

# create public IP
$PublicIPSplat = @{
    Name = $PublicIPName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AllocationMethod = $AllocationMethod
}
$PublicIP = New-AzPublicIpAddress @PublicIPSplat

# define values for load balancer
$LBName = "DEMO_LoadBalancer"
$LBFrontEnd = New-AzLoadBalancerFrontendIpConfig -Name "DEMO_LBFrontEnd" -PublicIpAddress $PublicIP

New-AzLoadBalancer -