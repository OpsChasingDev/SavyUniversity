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
$LBBackEnd = New-AzLoadBalancerBackendAddressPoolConfig -Name "DEMO_LBBackEnd"
$LBProbe = New-AzLoadBalancerProbeConfig -Name "DEMO_LBProbe" -Protocol "http" -Port 80 -IntervalInSeconds 15 -ProbeCount 2 -RequestPath "healthcheck.aspx"
$LBRule = New-AzLoadBalancerRuleConfig -Name "DEMO_LBRule" -FrontendIpConfiguration $LBFrontEnd -BackendAddressPool $LBBackEnd -Probe $LBProbe -Protocol "tcp" -FrontendPort 80 -BackendPort 80 -IdleTimeoutInMinutes 15

# create load balancer
$LBSplat = @{
    Name = $LBName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    FrontendIpConfiguration = $LBFrontEnd
    BackendAddressPool = $LBBackEnd
    Probe = $LBProbe
    LoadBalancingRule = $LBRule
}
$LB = New-AzLoadBalancer @LBSplat

