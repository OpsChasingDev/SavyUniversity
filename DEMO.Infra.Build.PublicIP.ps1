function Build-RSPublicIP {
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Location
    )

    # define values for public IP address
    $PublicIPName = $ResourceGroupName + "_PublicIP"
    $AllocationMethod = "Static"

    # create public IP
    $PublicIPSplat = @{
        Name              = $PublicIPName
        ResourceGroupName = $ResourceGroupName
        Location          = $Location
        AllocationMethod  = $AllocationMethod
    }

    New-AzPublicIpAddress @PublicIPSplat
}