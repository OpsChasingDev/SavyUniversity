# The targeted final goal for a "push button" method of full infrastructure deployment
# Comments below list the order of operations under which the infrastructure will need to be built

Connect-AzAccount

$ResourceGroupName = "DEMO"
$Location = "eastus2"

## resource group
Build-RSResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location

## virtual network
Build-RSVNET -ResourceGroupName $ResourceGroupName -Location $Location

## public IP

## peering

## availability set

# load balancer

## VMs, including disks, NICs, and assigning to the availability set and load balancer