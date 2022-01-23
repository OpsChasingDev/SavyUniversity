# connect to Azure sub
Connect-AzAccount

# create resource group
New-AzResourceGroup -Name "Demo_Resource_Group" -Location 'eastus2'

# create virtual machine
$splat = @{
    ResourceGroupName = 'Demo_Resource_Group'
    Name = 'DEMO-VM-01'
    Image = 'Win2019Datacenter'
    Size = 'Standard_B1ms'
    Credential = Get-Credential
    OpenPorts = '3389'
}

New-AzVM @splat