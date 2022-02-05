# this script assumes you are already connected to your Azure account

$VMAll = Get-AzResourceGroup 'demo' | Get-AzVM -Status

foreach ($vm in $VMAll) {
    $Name = $vm.Name
    $PowerState = $vm.PowerState
    Write-Output "$Name : $PowerState"
}