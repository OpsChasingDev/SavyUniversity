# this script assumes you are already connected to your Azure account

param (
    [Parameter(Mandatory)]
    [string]$VMName
)

$PowerState = (Get-AzVM -Name $VMName -Status).PowerState

if ($PowerState -eq "VM running") {
    Write-Host 'the vm is running'
}