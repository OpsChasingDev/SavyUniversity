# removes all resources from the DEMO resourcegroup except the VNET
Get-AzResource -ResourceGroupName 'demo' | Where-Object {$_.Type -ne "Microsoft.Network/virtualNetworks"} | Remove-AzResource