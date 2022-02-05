# this script assumes you are already connected to your Azure account

param (
    [string]$VMName
)

Get-AzVM -Name $VMName -Status | Select-Object PowerState