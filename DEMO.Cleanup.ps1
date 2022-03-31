$Answer = Read-Host "Are you sure you want to remove the Resource Group 'DEMO' and all of its components? [Y/N]"
$ResourceGroupName = 'Sandbox'
if ($Answer -eq 'Y') {
    $VNET = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName
    $VNETPeer = Get-AzVirtualNetworkPeering -VirtualNetworkName $VNET.Name -ResourceGroupName $ResourceGroupName
    Remove-AzVirtualNetworkPeering -Name $VNETPeer -VirtualNetworkName $VNET.name -ResourceGroupName $ResourceGroupName
}
    
    Remove-AzResourceGroup -Name 'DEMO'