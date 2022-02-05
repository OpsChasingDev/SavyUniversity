Connect-AzAccount

$AllVM = Get-AzResourceGroup 'demo' | Get-AzVM

foreach ($vm in $AllVM){
    $VMName = $vm.Name
    Stop-AzVM -Name $VMName -ResourceGroupName 'demo' -Force
}