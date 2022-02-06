# uses a series of constructions to generate attributes of a virtual machine, its virtual network, and its credentials
# the attributes are stored together in a VMConfig and then is passed to the VM creation at the end
# time for 3 VMs: ~3.5 minutes

param (
    [Parameter(Mandatory)]
    [int]$VMNumber
)

$VerbosePreference = 'Continue'

# identify resource group and region
$ResourceGroupName = "DEMO"
$Location = "eastus2"

# construct virtual network
$NetworkName = "DEMO_VNET"
$SubnetName = "DEMO_Subnet"
$SubnetAddress = '192.168.0.0/24'
$VirtualNetworkAddressPrefix = '192.168.0.0/16'
$Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddress
$VirutalNetworkSplat = @{
    Name = $NetworkName
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    AddressPrefix = $VirtualNetworkAddressPrefix
    Subnet = $Subnet
}
$VirtualNetwork = New-AzVirtualNetwork @VirutalNetworkSplat
$SubnetId = $VirtualNetwork.Subnets.Id

# construct network adapter
for ($v = 1; $v -le $VMNumber; $v++) {
    $NICName = "DEMO-VM-" + $v + "_NIC"
    $NICSplat = @{
        Name = $NICName
        ResourceGroupName = $ResourceGroupName
        Location = $Location
        SubnetId = $SubnetId
    }
    $NIC = New-AzNetworkInterface @NICSplat

    # construct VM local credentials
    $LocalAdmin = "RStapleton"
    $LocalPass = ConvertTo-SecureString "SomethingB3tt3r!@#" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalAdmin,$LocalPass)

    # construct VM attributes
    $Name = "DEMO-VM-" + $v
    $Size = "Standard_B1ms"

    # construct VM object
    $VM = New-AzVMConfig -VMName $Name -VMSize $Size
    $VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $Name -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
    $VM = Add-AzVMNetworkInterface -VM $VM -Id $NIC.Id
    $VM = Set-AzVMSourceImage -VM $VM -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter-Core' -Version latest

    # make VM
    New-AzVM -VM $VM -ResourceGroupName $ResourceGroupName -Location $Location -AsJob
}

do {
    $VMBuild = Get-Job | Where-Object {$_.State -eq 'Running'}
    Write-Verbose "Working..."
    Start-Sleep -Seconds 10
} while ($VMBuild)
Write-Verbose "Construction completed."