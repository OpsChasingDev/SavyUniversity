# this script assumes you are already connected to your Azure account

$AllVM = Get-AzResourceGroup 'demo' | Get-AzVM

foreach ($vm in $AllVM){
    $VMName = $vm.Name
    Stop-AzVM -Name $VMName -ResourceGroupName 'demo' -Force -AsJob
}