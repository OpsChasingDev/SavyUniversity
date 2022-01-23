# creates VMs in the 'demo' Resource Group
Param (
    [Parameter(Mandatory)]
    [int]$VMNumber
)

# connect to Azure sub
Connect-AzAccount

# store credentials for VMs
$cred = Get-Credential

# create virtual machines
for ($i=1; $i -le $VMNumber; $i++) {
    $splat = @{
        ResourceGroupName = 'Demo'
        VirtualNetworkName = 'demo-vnet'
        Name = 'DEMO-VM-' + $i
        Image = 'Win2019Datacenter'
        Size = 'Standard_B1ms'
        Credential = $cred
        OpenPorts = '3389'
    }
    New-AzVM @splat
}