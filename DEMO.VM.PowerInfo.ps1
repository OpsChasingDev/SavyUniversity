$VMAll = Get-AzResourceGroup 'demo' | Get-AzVM -Status

foreach ($vm in $VMAll) {
    $Name = $vm.Name
    $PowerState = $vm.PowerState
    Write-Output "$Name : $PowerState"
}