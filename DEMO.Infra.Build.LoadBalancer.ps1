function Build-RSLoadBalancer {
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Location
    )

    # define values for load balancer
    $PublicIPName = $ResourceGroupName + "_PublicIP"
    $PublicIP = Get-AzPublicIpAddress -Name $PublicIPName
    $LBName = $ResourceGroupName + "_LoadBalancer"
    $LBFrontEndName = $ResourceGroupName + "_LBFrontEnd"
    $LBBackEndName = $ResourceGroupName + "_LBBackEnd"
    $LBProbeName = $ResourceGroupName + "_LBProbe"
    $LBRuleName = $ResourceGroupName + "_LBRule"

    $LBFrontEnd = New-AzLoadBalancerFrontendIpConfig -Name $LBFrontEndName -PublicIpAddress $PublicIP
    $LBBackEnd = New-AzLoadBalancerBackendAddressPoolConfig -Name $LBBackEndName
    $LBProbe = New-AzLoadBalancerProbeConfig -Name $LBProbeName -Protocol "http" -Port 80 -IntervalInSeconds 15 -ProbeCount 2 -RequestPath "\"
    $LBRuleConfigSplat = @{
        Name = $LBRuleName
        FrontendIpConfiguration = $LBFrontEnd
        BackendAddressPool = $LBBackEnd
        Probe = $LBProbe
        Protocol = 'tcp'
        FrontendPort = 80
        BackendPort = 80
        IdleTimeoutInMinutes = 15
    }
    $LBRule = New-AzLoadBalancerRuleConfig @LBRuleConfigSplat

    # create load balancer
    $LBSplat = @{
        Name                    = $LBName
        ResourceGroupName       = $ResourceGroupName
        Location                = $Location
        FrontendIpConfiguration = $LBFrontEnd
        BackendAddressPool      = $LBBackEnd
        Probe                   = $LBProbe
        LoadBalancingRule       = $LBRule
    }
    New-AzLoadBalancer @LBSplat
}