# cleans up the 'DEMO' resource group along with the remote end of the virtual network peer created in the 'Sandbox' resource group

$VerbosePreference = 'Continue'

$ResourceGroupName = Read-Host "Enter the name of the resouce group to remove."
$RemoteResourceGroup = 'Sandbox'
$VNET = Get-AzVirtualNetwork -ResourceGroupName $RemoteResourceGroup
$VNETPeer = Get-AzVirtualNetworkPeering -VirtualNetworkName $VNET.Name -ResourceGroupName $RemoteResourceGroup
$StorageAccount = 'savylabsandbox'

$Answer = Read-Host "Are you sure you want to remove the resource group $ResourceGroupName and all of its components? [Y/N]"

if ($Answer -eq 'Y') {

    # removes remote end of VNET peer
    if ($VNETPeer) {
        foreach ($v in $VNETPeer) {
            $VNETPeerName = $v.Name
            Write-Verbose "Removing network peer $VNETPeerName from the remote side in $RemoteResourceGroup..."
            Remove-AzVirtualNetworkPeering -Name $VNETPeerName -VirtualNetworkName $VNET.Name -ResourceGroupName $RemoteResourceGroup -Force
            Write-Verbose "Network peer $VNETPeerName removed from $RemoteResourceGroup."
        }
    }
    else {
        Write-Output "No remote network peer was found in $RemoteResourceGroup."
    }

    # removes all resources in the resource group
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if ($rg) {
        Write-Verbose "Removing resource group $ResourceGroupName.  This may take a few minutes..."
        Remove-AzResourceGroup -Name $ResourceGroupName -Force
        Write-Verbose "Removing resource group $ResourceGroupName completed."
    }
    else {
        Write-Output "No resource group called $ResourceGroupName was found."
    }

    # removes bootdiagnostics containers in blob storage for the removed VMs
    $Context = New-AzStorageContext -StorageAccountName $StorageAccount
    $BootDiagName = 'bootdiagnostics-' + $ResourceGroupName
    $BootDiagItem = (Get-AzStorageContainer -Context $Context | Where-Object {$_.Name -like "$BootDiagName*"}).Name
    foreach ($b in $BootDiagItem) {
        Remove-AzStorageContainer -Context $Context -Name $b -Force
    }
}