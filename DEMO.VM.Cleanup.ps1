# removes all resources from the DEMO resourcegroup except the VNET
Get-AzResource -ResourceGroupName 'demo' | Where-Object name -like "*demo-vm-*" | Remove-AzResource -WhatIf