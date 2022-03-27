function Build-VMImage {
    param (
        [Parameter(Mandatory)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [string]$Location
    )
    $ResourceGroupName = 'DEMO'
    $Location = 'eastus2'
    $ImageName = 'Server-2022-Core-WinRM'
    $ImageURI = 'https://savylabsandbox.blob.core.windows.net/vhdx/Server-2022-Core-WinRM-Gen1.vhd'

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
}