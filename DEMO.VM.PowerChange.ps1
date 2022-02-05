# this script assumes you are already connected to your Azure account

$Read = Read-Host "Type 'ON' to power on all DEMO VMs or 'OFF' to power off all DEMO VMs."

if ($Read -eq 'OFF'){
    $AllVM = Get-AzResourceGroup 'demo' | Get-AzVM
    foreach ($vm in $AllVM){
        $VMName = $vm.Name
        Stop-AzVM -Name $VMName -ResourceGroupName 'demo' -Force -AsJob
    }
}
elseif ($Read -eq 'ON'){
    $AllVM = Get-AzResourceGroup 'demo' | Get-AzVM
    foreach ($vm in $AllVM){
        $VMName = $vm.Name
        Start-AzVM -Name $VMName -ResourceGroupName 'demo' -AsJob
    }
}
else {
    Write-Output "Well, run me again if you make up your mind."
}