# https://www.youtube.com/watch?v=_b5T-dPpd00

$Name = 'VM'
$ResourceGroupName = 'DEMO'
$Location = 'eastus2'
$ImageName = 'Server-2022-Core-WinRM'
$ImageURI = 'https://savylabsandbox.blob.core.windows.net/vhdx/Server-2022-Core-WinRM.vhd'
$VHDUri = 'https://savylabsandbox.blob.core.windows.net/disks'
$LocalAdmin = "RStapleton"
$LocalPass = ConvertTo-SecureString "SomethingB3tt3r!@#" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalAdmin,$LocalPass)
$VirtualNetwork = Get-AzVirtualNetwork -Name 'DEMO_VNET'
$SubnetId = $VirtualNetwork.Subnets.Id
$NICSplat = @{
    Name = 'testvm_NIC'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    SubnetId = $SubnetId
}
$NIC = New-AzNetworkInterface @NICSplat

<#
$VM = New-AzVMConfig -VMName 'testvm' -VMSize "Standard_B1ms"
$VM = Add-AzVMNetworkInterface -VM $VM -Id $NIC.Id
$VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName "TestVM" -Credential $Credential
$VM = Set-AzVMOSDisk -VM $VM -Name "osDisk.vhd" -SourceImageUri $ImageURI -CreateOption fromImage -Windows
New-AzVM -VM $VM -ResourceGroupName $ResourceGroupName -Location $Location
#>

# create image config
$Image = New-AzImageConfig -Location $Location

# add OS information to the image config
$ImageConfigSplat = @{
    Image = $Image
    OsType = 'Windows'
    OsState = 'Generalized'
    BlobUri = $ImageURI
    DiskSizeGB = 65
}
$Image = Set-AzImageOsDisk @ImageConfigSplat

# create the image from the config
$ImageSplat = @{
    ImageName = $ImageName
    ResourceGroupName = $ResourceGroupName
    Image = $Image
}
New-AzImage @ImageSplat

$VMSplat = @{
    Name
    Image
    ResourceGroupName
    Location
    VirtualNetworkName
}
New-AzVM @VMSplat