param (
    [Parameter(Mandatory)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory)]
    [string]$Location
)

$AvailabilitySetName = $ResourceGroupName + "_AvailabilitySet"
$Sku = "Aligned"
$FaultDomain = 2
$UpdateDomain = 5

$AvailabilitySetSplat = @{
    Name = $AvailabilitySetName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    Sku = $Sku
    PlatformFaultDomainCount = $FaultDomain
    PlatformUpdateDomainCount = $UpdateDomain
}

New-AzAvailabilitySet @AvailabilitySetSplat
Write-Verbose "Created availability set $AvailabilitySetName."