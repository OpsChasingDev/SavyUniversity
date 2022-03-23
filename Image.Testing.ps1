$Name = 'VM'
$ResourceGroupName = 'DEMO'
$Location = 'eastus2'
$ImageName = 'Server-2022-Core-WinRM'
$VHDUri = 'https://savylabsandbox.blob.core.windows.net/vhdx/Server-2022-Core-WinRM.vhd'

$ImageConfig = New-AzImageConfig -Location $Location
$ImageConfig = Set-AzImageOsDisk -Image $ImageConfig -OsType Windows -OsState generalized -BlobUri $VHDUri
$Image = New-AzImage -ImageName $ImageName -ResourceGroupName $ResourceGroupName -Image $ImageConfig

Add-AzVhd -ResourceGroupName $ResourceGroupName -Destination $VHDUri -LocalFilePath 'D:\Hyper-V\Server-2022-Core-WinRM_Converted.vhd' -OverWrite

#New-AzVM -ResourceGroupName $ResourceGroupName -Name $Name -