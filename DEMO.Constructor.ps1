# The targeted final goal for a "push button" method of full infrastructure deployment
# Comments below list the order of operations under which the infrastructure will need to be built

. "C:\git\SavyUniversity\DEMO.Infra.Build.ResourceGroup.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.VNET.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.VM.Image.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.PublicIP.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.Peer.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.AvailabilitySet.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.LoadBalancer.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.VM.ps1"
. "C:\git\SavyUniversity\DEMO.Infra.Build.VM.Config.ps1"

Connect-AzAccount

# VM local password creation - used to both set a local admin account on the VM creation
# and provide any VM configuration scripts the credentials for remote PowerShell connections
$User = Read-Host "Enter a Local Username"
$Pass = Read-Host "Enter a Password"
$Pass = ConvertTo-SecureString "$Pass" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($User,$Pass)

$ResourceGroupName = "DEMO"
$Location = "eastus2"
$VMNumber = Read-Host "Enter the number of VMs to make"

## resource group
$RSResourceGroupSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSResourceGroup @$RSResourceGroupSplat -OutVariable RSResourceGroup > $null

## virtual network
$RSVNETSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSVNET @RSVNETSplat -OutVariable RSVNET > $null

## VM image
$RSVMImageSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSVMImage @RSVMImageSplat -OutVariable RSVMImage > $null

## public IP
$RSPublicIPSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSPublicIP @RSPublicIPSplat -OutVariable RSPublicIP > $null

## peering
Build-RSPeer -ResourceGroupName $ResourceGroupName -OutVariable RSPeer > $null

## availability set
$RSAvailabilitySetSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSAvailabilitySet @RSAvailabilitySetSplat -OutVariable RSAvailabilitySet > $null

## load balancer
$RSLoadBalancerSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSLoadBalancer @RSLoadBalancerSplat -OutVariable RSLoadBalancer > $null

## VMs, including disks, NICs, and assigning to the availability set and load balancer
$RSVMSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    VMNumber = $VMNumber
    Credential = $Credential
}
Build-RSVM @RSVMSplat -OutVariable RSVM > $null

## VM configuration
Build-RSVMConfig -Credential $Credential