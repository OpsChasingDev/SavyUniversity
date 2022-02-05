# this script assumes you are already connected to your Azure account
# returns the power state for all VMs running in the DEMO Azure resource group

$VMAll = Get-AzResourceGroup 'demo' | Get-AzVM -Status

foreach ($vm in $VMAll) {
    $Name = $vm.Name
    $PowerState = $vm.PowerState
    Write-Output "$Name : $PowerState"
}