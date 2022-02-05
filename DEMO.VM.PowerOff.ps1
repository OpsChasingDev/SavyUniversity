# this script assumes you are already connected to your Azure account

$AllVM = Get-AzResourceGroup 'demo' | Get-AzVM

$Read = Read-Host "Type 'yes' to power off all of the VMs in the DEMO resource group"

if ($Read -eq 'yes'){
    foreach ($vm in $AllVM){
        $VMName = $vm.Name
        Stop-AzVM -Name $VMName -ResourceGroupName 'demo' -Force -AsJob
    }
}
else {
    Write-Output "Well, run me again if you make up your mind.1"
}