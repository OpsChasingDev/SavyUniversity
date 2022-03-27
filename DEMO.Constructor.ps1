# The targeted final goal for a "push button" method of full infrastructure deployment
# Comments below list the order of operations under which the infrastructure will need to be built

. "c:\git\SavyUniversity\DEMO.Infra.Build.ResourceGroup.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.VNET.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.PublicIP.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.Peer.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.AvailabilitySet.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.LoadBalancer.ps1"
. "c:\git\SavyUniversity\DEMO.Infra.Build.VM.ps1"

Connect-AzAccount

$ResourceGroupName = "DEMO"
$Location = "eastus2"
$VMNumber = 2

## resource group
Build-RSResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location

## virtual network
Build-RSVNET -ResourceGroupName $ResourceGroupName -Location $Location

## VM image
Build-VMImage -ResourceGroupName $ResourceGroupName -Location $Location

## public IP
Build-RSPublicIP -ResourceGroupName $ResourceGroupName -Location $Location

## peering
Build-RSPeer -ResourceGroupName $ResourceGroupName

## availability set
Build-RSAvailabilitySet -ResourceGroupName $ResourceGroupName -Location $Location

## load balancer
Build-RSLoadBalancer -ResourceGroupName $ResourceGroupName -Location $Location

## VMs, including disks, NICs, and assigning to the availability set and load balancer
Build-RSVM -ResourceGroupName $ResourceGroupName -Location $Location -VMNumber $VMNumber