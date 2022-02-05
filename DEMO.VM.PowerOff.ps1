param (
    [Parameter(Mandatory)]
    [string]$VMName
)

Connect-AzAccount

Get-AzResourceGroup | Get-AzVM

$VM = Get-AzVM -Name $VMName -Status
$PowerState = $VM.PowerState
$Name = $VM.Name

if ($PowerState -eq "VM running") {
    Write-Host "About to shut down virtual machine: $Name"
    Stop-AzVM -Name $Name -ResourceGroupName 'Sandbox'
}