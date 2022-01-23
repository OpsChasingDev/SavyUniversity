Param (
    [Parameter(Mandatory)]
    [int]$VMNumber
)

# connect to Azure sub
Connect-AzAccount

# store credentials for VMs
$cred = Get-Credential

# create resource group
New-AzResourceGroup -Name "Demo_Resource_Group" -Location 'eastus2'

# create virtual machines
for ($i=1; $i -le $VMNumber; $i++) {
    $splat = @{
        ResourceGroupName = 'Demo_Resource_Group'
        Name = 'DEMO-VM-0' + $i
        Image = 'Win2019Datacenter'
        Size = 'Standard_B1ms'
        Credential = $cred
        OpenPorts = '3389'
    }
    New-AzVM @splat
}