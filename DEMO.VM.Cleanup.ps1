# removes all non-vnet resources from the DEMO resourcegroup
# time for 3 VMs: ~6 minutes
# new time after parallel: ~3 minutes

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

$VerbosePreference = 'Continue'

if ($Read -eq "yes"){

    # virtual machine removal
    $VirtualMachine = Get-AzResource -ResourceGroupName "demo" | Where-Object {$_.Type -eq "Microsoft.Compute/virtualMachines"}
    foreach ($m in $VirtualMachine) {
        $m | Remove-AzResource -Force -AsJob
    }
    do {
        $JobVirtualMachine = Get-Job | Where-Object {$_.State -eq 'Running'}
        Write-Verbose "Working..."
        Start-Sleep -Seconds 5
    } while ($JobVirtualMachine)
    Write-Verbose "All virtual machines removed."

    # virtual disk removal
    $VirtualDisk = Get-AzResource -ResourceGroupName "demo" | Where-Object {$_.Type -eq "Microsoft.Compute/disks"}
    foreach ($d in $VirtualDisk) {
        $d | Remove-AzResource -Force -AsJob
    }
    do {
        $JobVirtualDisk = Get-Job | Where-Object {$_.State -eq 'Running'}
        Write-Verbose "Working..."
        Start-Sleep -Seconds 5
    } while ($JobVirtualDisk)
    Write-Verbose "All virtual disks removed."

    # virtual network interface removal
    $VirtualNetworkInterface = Get-AzResource -ResourceGroupName "demo" | Where-Object {$_.Type -eq "Microsoft.Network/networkInterfaces"}
    foreach ($n in $VirtualNetworkInterface) {
        $n | Remove-AzResource -Force -AsJob
    }
    do {
        $JobVirtualNetworkInterface = Get-Job | Where-Object {$_.State -eq 'Running'}
        Write-Verbose "Working..."
        Start-Sleep -Seconds 5
    } while ($JobVirtualNetworkInterface)
    Write-Verbose "All virtual network interfaces removed."
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