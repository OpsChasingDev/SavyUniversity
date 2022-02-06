# removes all non-vnet resources from the DEMO resourcegroup

$Read = Read-Host "Do you want to remove all non-vnet resources in the Resource Group 'DEMO'?  Type 'yes' to confirm."

if($Read -eq "yes") {
    do {
        $Resource = Get-AzResource -ResourceGroupName 'demo' | Where-Object {$_.Type -ne "Microsoft.Network/virtualNetworks"}
        $Resource | Remove-AzResource -Force -ErrorAction SilentlyContinue
    } while ($Resource)
}