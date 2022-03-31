$Answer = Read-Host "Are you sure you want to remove the Resource Group 'DEMO' and all of its components? [Y/N]"

if ($Answer -eq 'Y') {
   
    $VNET = Get-AzVirtualNetworkPeering -ResourceGroupName 'Sandbox' -VirtualNetworkName 'Sandbox-vnet'
    Remove-AzVirtualNetworkPeering -Name $VNET.Name
    
    Remove-AzResourceGroup -Name 'DEMO'
}