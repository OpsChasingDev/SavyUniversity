# uses a series of constructions to generate attributes of a virtual machine, its virtual network, and its credentials
# the attributes are stored together in a VMConfig and then is passed to the VM creation at the end

# construct VM attributes
$Name = "DEMO-VM-1"
$ResourceGroupName = "demo"
$Location = "eastus2"
$Size = "Standard_B1ms"

# construct VM networking
$NetworkName = "default-network-name"
$NICName = "default-NIC-name"
$SubnetName = "default-test"
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
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VirtualNetwork.Subnets[0].Id

# construct VM local credentials
$LocalAdmin = "RStapleton"
$LocalPass = ConvertTo-SecureString "P@ssword123" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalAdmin,$LocalPass)

# construct VM object
$VM = New-AzVMConfig -VMName $Name -VMSize $Size
$VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $Name -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VM = Add-AzVMNetworkInterface -VM $VM -Id $NIC.Id
$VM = Set-AzVMSourceImage -VM $VM -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter-Core' -Version latest

New-AzVM -VM $VM -ResourceGroupName $ResourceGroupName -Location $Location -Verbose
