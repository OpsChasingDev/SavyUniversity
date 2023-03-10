function Build-RSResourceGroup {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Location
    )

    New-AzResourceGroup -Name $ResourceGroupName -Location $Location

}