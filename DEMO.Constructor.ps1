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
$VerbosePreference = 'Continue'

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
Write-Verbose "Creating resource group $ResourceGroupName in the location $Location..."
$RSResourceGroupSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSResourceGroup @RSResourceGroupSplat -OutVariable RSResourceGroup > $null
Write-Verbose "Resource group completed."

## virtual network
Write-Verbose "Creating virtual network for resource group $ResourceGroupName..."
$RSVNETSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSVNET @RSVNETSplat -OutVariable RSVNET > $null
Write-Verbose "Virtual network completed."

## VM image
Write-Verbose "Creating virtual machine image for resource group $ResourceGroupName..."
$RSVMImageSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSVMImage @RSVMImageSplat -OutVariable RSVMImage > $null
Write-Verbose "Virtual machine image completed."

## public IP
Write-Verbose "Creating public IP for resource group $ResourceGroupName..."
$RSPublicIPSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSPublicIP @RSPublicIPSplat -OutVariable RSPublicIP > $null
Write-Verbose "Public IP completed."

## peering
Write-Verbose "Creating virtual network peering for the virtual network in $ResourceGroupName..."
Build-RSPeer -ResourceGroupName $ResourceGroupName -OutVariable RSPeer > $null
Write-Verbose "Virtual networking peering completed."

## availability set
Write-Verbose "Creating availability set for resource group $ResourceGroupName..."
$RSAvailabilitySetSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSAvailabilitySet @RSAvailabilitySetSplat -OutVariable RSAvailabilitySet > $null
Write-Verbose "Availability set completed."

## load balancer
Write-Verbose "Creating the load balancer for resource group $ResourceGroupName..."
$RSLoadBalancerSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
}
Build-RSLoadBalancer @RSLoadBalancerSplat -OutVariable RSLoadBalancer > $null
Write-Verbose "Load balancer completed."

## VMs, including disks, NICs, and assigning to the availability set and load balancer
Write-Verbose "Creating $VMNumber virtual machine(s) for resource group $ResourceGroupName..."
$RSVMSplat = @{
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    VMNumber = $VMNumber
    Credential = $Credential
}
Build-RSVM @RSVMSplat -OutVariable RSVM > $null
Write-Verbose "Virtual machine(s) completed."

## VM configuration
Write-Verbose "Configuring the virtual machine(s) in resource group $ResourceGroupName..."
Build-RSVMConfig -Credential $Credential
Write-Verbose "Virtual machine(s) configuration completed."