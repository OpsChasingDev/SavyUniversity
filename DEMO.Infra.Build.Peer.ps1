$VerbosePreference = 'Continue'

$VNET_Demo = Get-AzVirtualNetwork -ResourceGroupName 'demo'
$VNET_Sandbox = Get-AzVirtualNetwork -ResourceGroupName 'sandbox'

$VNET_Demo_Job = Add-AzVirtualNetworkPeering -Name "DEMO_to_Sandbox" -VirtualNetwork $VNET_Demo -RemoteVirtualNetworkId $VNET_Sandbox.Id -AsJob
$VNET_Sandbox_Job = Add-AzVirtualNetworkPeering -Name "Sandbox_to_DEMO" -VirtualNetwork $VNET_Sandbox -RemoteVirtualNetworkId $VNET_Demo.Id -AsJob

do {
    Write-Verbose "Working..."
    Start-Sleep -Seconds 5
} while ($VNET_Demo_Job.State -ne 'Completed')

Write-Verbose "Peer DEMO_to_Sandbox created."

do {
    Write-Verbose "Working..."
    Start-Sleep -Seconds 5
} while ($VNET_Sandbox_Job.State -ne 'Completed')

Write-Verbose "Peer Sandbox_to_DEMO created."

Write-Verbose "Construction completed."