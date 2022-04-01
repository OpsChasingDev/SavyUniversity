$Answer = Read-Host "Are you sure you want to remove the resource group 'DEMO' and all of its components? [Y/N]"
$ResourceGroupName = 'Sandbox'
if ($Answer -eq 'Y') {
    
    Write-Verbose "Removing network peer from the remote side in $ResourceGroupName..."
    $VNET = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName
    $VNETPeer = Get-AzVirtualNetworkPeering -VirtualNetworkName $VNET.Name -ResourceGroupName $ResourceGroupName
    Remove-AzVirtualNetworkPeering -Name $VNETPeer.Name -VirtualNetworkName $VNET.Name -ResourceGroupName $ResourceGroupName -Force
    Write-Verbose "Removing network peer completed."

    Write-Verbose "Removing resource group 'DEMO'.  This may take a few minutes..."
    Remove-AzResourceGroup -Name 'DEMO' -Force
    Write-Verbose "Removing resource group 'DEMO' completed."
}
    