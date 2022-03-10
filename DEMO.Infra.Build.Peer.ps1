param (
    [Parameter(Mandatory)]
    [string]$ResourceGroupName
)

$VerbosePreference = 'Continue'

$VNET_Target = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName
$VNET_Sandbox = Get-AzVirtualNetwork -ResourceGroupName 'Sandbox'

$ForwardName = $ResourceGroupName + "_to_Sandbox"
$BackwardName = "Sandbox_to_" + $ResourceGroupName

$VNET_Target_Job = Add-AzVirtualNetworkPeering -Name $ForwardName -VirtualNetwork $VNET_Target -RemoteVirtualNetworkId $VNET_Sandbox.Id -AsJob
$VNET_Sandbox_Job = Add-AzVirtualNetworkPeering -Name $BackwardName -VirtualNetwork $VNET_Sandbox -RemoteVirtualNetworkId $VNET_Target.Id -AsJob

do {
    Write-Verbose "Working..."
    Start-Sleep -Seconds 5
} while ($VNET_Target_Job.State -ne 'Completed')

Write-Verbose "Peer $ForwardName created."

do {
    Write-Verbose "Working..."
    Start-Sleep -Seconds 5
} while ($VNET_Sandbox_Job.State -ne 'Completed')

Write-Verbose "Peer $BackwardName created."

Write-Verbose "Construction completed."