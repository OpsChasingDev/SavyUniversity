# this script assumes you are already connected to your Azure account

param (
    [Parameter(Mandatory)]
    [string]$VMName
)

$VM = Get-AzVM -Name $VMName -Status
$PowerState = $VM.PowerState
$Name = $VM.Name

if ($PowerState -eq "VM running") {
    Write-Host "stopping vm $Name"
    Stop-AzVM -Name $Name -ResourceGroupName 'DEMO'
}
else {
    Write-Host "it didn't work"
}
