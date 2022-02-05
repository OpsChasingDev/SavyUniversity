# this script assumes you are already connected to your Azure account

param (
    [Parameter(Mandatory)]
    [string]$ResourceGroup
)

$Read = Read-Host "Modifying power state of ALL VMs for the Resource Group: $ResourceGroup.  Type 'ON' to power on or 'OFF' to power off."

if ($Read -eq 'OFF'){
    $AllVM = Get-AzResourceGroup $ResourceGroup | Get-AzVM
    foreach ($vm in $AllVM){
        $VMName = $vm.Name
        Stop-AzVM -Name $VMName -ResourceGroupName $ResourceGroup -Force -AsJob
    }
}
elseif ($Read -eq 'ON'){
    $AllVM = Get-AzResourceGroup $ResourceGroup | Get-AzVM
    foreach ($vm in $AllVM){
        $VMName = $vm.Name
        Start-AzVM -Name $VMName -ResourceGroupName $ResourceGroup -AsJob
    }
}
else {
    Write-Output "Well, run me again if you make up your mind."
}