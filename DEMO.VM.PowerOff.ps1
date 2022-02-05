Connect-AzAccount

$AllVM = Get-AzResourceGroup 'demo' | Get-AzVM

foreach ($vm in $AllVM){
    $VMName = $vm.Name
    Stop-AzVM -Name $VMName -ResourceGroupName 'demo' -Force
}

$VM = Get-AzVM -Name $VMName -Status
$PowerState = $VM.PowerState
$Name = $VM.Name

if ($PowerState -eq "VM running") {
    Write-Host "About to shut down virtual machine: $Name"
    Stop-AzVM -Name $Name -ResourceGroupName 'Sandbox'
}