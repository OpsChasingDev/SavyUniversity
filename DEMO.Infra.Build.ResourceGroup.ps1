
param (
    [Parameter(Mandatory)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory)]
    [string]$Location
)
Connect-AzAccount
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

