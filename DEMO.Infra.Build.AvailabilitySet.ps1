$AvailabilitySetName = "DEMO_AvailabilitySet"
$ResourceGroupName = "DEMO"
$Location = "eastus2"

$AvailabilitySetSplat = @{
    Name = $AvailabilitySetName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}

New-AzAvailabilitySet @AvailabilitySetSplat
Write-Verbose "Created availability set $AvailabilitySetName."