$ResourceGroupName = 'DEMO'
$RemoteResourceGroup = 'Sandbox'
$Answer = Read-Host "Are you sure you want to remove the resource group $ResourceGroupName and all of its components? [Y/N]"
if ($Answer -eq 'Y') {
    
    Write-Verbose "Removing network peer from the remote side in $RemoteResourceGroup..."
    $VNET = Get-AzVirtualNetwork -RemoteResourceGroup $RemoteResourceGroup
    $VNETPeer = Get-AzVirtualNetworkPeering -VirtualNetworkName $VNET.Name -RemoteResourceGroup $RemoteResourceGroup
    Remove-AzVirtualNetworkPeering -Name $VNETPeer.Name -VirtualNetworkName $VNET.Name -RemoteResourceGroup $RemoteResourceGroup -Force
    Write-Verbose "Network peer removed from $RemoteResourceGroup."

    Write-Verbose "Removing resource group $ResourceGroupName.  This may take a few minutes..."
    Remove-AzResourceGroup -Name $ResourceGroupName -Force
    Write-Verbose "Removing resource group $ResourceGroupName completed."
}
    