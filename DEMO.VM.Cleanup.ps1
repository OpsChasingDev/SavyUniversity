# removes all resources from the DEMO resourcegroup except the VNET

$Read = Read-Host "Do you want to remove all non-vnet resources in the Resource Group 'DEMO'?  Type 'yes' to confirm."

if($Read -eq "yes") {
    Get-AzResource -ResourceGroupName 'demo' | Where-Object {$_.Type -ne "Microsoft.Network/virtualNetworks"} | Remove-AzResource -Force
}