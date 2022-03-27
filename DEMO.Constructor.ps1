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
#$LocalAdmin = $Credential.UserName
#$LocalPass = $Credential.Password

## resource group
Build-RSResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location

## virtual network
Build-RSVNET -ResourceGroupName $ResourceGroupName -Location $Location

## VM image
Build-RSVMImage -ResourceGroupName $ResourceGroupName -Location $Location

## public IP
Build-RSPublicIP -ResourceGroupName $ResourceGroupName -Location $Location

## peering
Build-RSPeer -ResourceGroupName $ResourceGroupName

## availability set
Build-RSAvailabilitySet -ResourceGroupName $ResourceGroupName -Location $Location

## load balancer
Build-RSLoadBalancer -ResourceGroupName $ResourceGroupName -Location $Location

## VMs, including disks, NICs, and assigning to the availability set and load balancer
$RSVMSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    VMNumber = $VMNumber
    Credential = $Credential
}
Build-RSVM @RSVMSplat

## VM configuration
Build-RSVMConfig -Credential $Credential