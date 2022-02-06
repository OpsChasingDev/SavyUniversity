# removes all non-vnet resources from the DEMO resourcegroup
# time for 3 VMs: ~6 minutes

$Read = Read-Host "Do you want to remove all non-vnet resources in the Resource Group 'DEMO'?  Type 'yes' to confirm."

<#
if($Read -eq "yes") {
    do {
        $Resource = Get-AzResource -ResourceGroupName 'demo' | Where-Object {$_.Type -ne "Microsoft.Network/virtualNetworks"}
        $Resource | Remove-AzResource -Force -ErrorAction SilentlyContinue
    } while ($Resource)
}
#>

# break

if ($Read -eq "yes"){
    $VirtualMachines = Get-AzResource -ResourceGroupName "demo" | Where-Object {$_.Type -eq "Microsoft.Compute/virtualMachines"}
    foreach ($m in $VirtualMachines) {
        $m | Remove-AzResource -Force -AsJob
    }
    do {
        $Job = Get-Job | Where-Object {$_.State -eq 'Running'}
        Write-Verbose "Working..."
        Start-Sleep -Seconds 5
    } while ($Job)
    Write-Verbose "All virtual machines removed."
}


<#
Microsoft.Network/networkInterfaces
Microsoft.Compute/virtualMachines
Microsoft.Compute/disks

Get-Job | where {$_.State -eq 'running'}

Members:
Id
State (Running, Completed)
#>