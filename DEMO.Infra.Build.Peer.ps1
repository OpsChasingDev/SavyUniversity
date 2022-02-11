$VNET_Demo = Get-AzVirtualNetwork -ResourceGroupName 'demo'
$VNET_Sandbox = Get-AzVirtualNetwork -ResourceGroupName 'sandbox'

Add-AzVirtualNetworkPeering -Name "DEMO_to_Sandbox" -VirtualNetwork $VNET_Demo -RemoteVirtualNetworkId $VNET_Sandbox.Id
Add-AzVirtualNetworkPeering -Name "Sandbox_to_DEMO" -VirtualNetwork $VNET_Sandbox -RemoteVirtualNetworkId $VNET_Demo.Id
