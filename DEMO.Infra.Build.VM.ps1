# uses a series of constructions to generate attributes of a virtual machine, its virtual network, and its credentials
# the attributes are stored together in a VMConfig and then is passed to the VM creation at the end
# time: 3-4 minutes
<#
For enabling remote powershell commands on the newly created VMs (running Server 2022 Core), run the below on each VM:
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress 10.0.0.5
    (the -RemoteAddress will be the IP address of whatever machine you wish to access the created VMs from)
You must also run the below command once on the machine from which you initiate your PS remoting:
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
Specifying credentials with your PS remoting will be necessary in order to establish connections
#>

function Build-RSVM {
    param (
        [Parameter(Mandatory)]
        [int]$VMNumber,

        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [string]$Location,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    $VerbosePreference = 'Continue'

    # identify resource group and region
    $AvailabilitySetName = $ResourceGroupName + "_AvailabilitySet"
    $AvailabilitySet = Get-AzAvailabilitySet -Name $AvailabilitySetName -ResourceGroupName $ResourceGroupName
    Write-Verbose "Operating in the Resource Group called $ResourceGroupName in the region $Location."

    # identify the subnet to use on the existing virtual network
    $VirtualNetworkName = $ResourceGroupName + "_VNET"
    $VirtualNetwork = Get-AzVirtualNetwork -Name $VirtualNetworkName
    $SubnetId = $VirtualNetwork.Subnets.Id
    $LBName = $ResourceGroupName + "_LoadBalancer"
    $LBBackEnd = Get-AzLoadBalancerBackendAddressPool -ResourceGroupName $ResourceGroupName -LoadBalancerName $LBName

    # VM construction
    for ($v = 1; $v -le $VMNumber; $v++) {
        # construct network adapter
        $NICName = $ResourceGroupName + "-VM-" + $v + "_NIC"
        $NICSplat = @{
            Name = $NICName
            ResourceGroupName = $ResourceGroupName
            Location = $Location
            SubnetId = $SubnetId
            LoadBalancerBackendAddressPoolId = $LBBackEnd.Id
        }
        $NIC = New-AzNetworkInterface @NICSplat

        # construct VM local credentials
        # $Credential = New-Object -TypeName System.Management.Automation.PSCredential ($LocalAdmin,$LocalPass)

        # construct VM attributes
        $Name = $ResourceGroupName + "-VM-" + $v
        $Size = "Standard_B1ms"
        $ImageId = (Get-AzResource -ResourceGroupName $ResourceGroupName | Where-Object {$_.ResourceType -eq 'Microsoft.Compute/images'}).id

        # construct VM object
        $VM = New-AzVMConfig -VMName $Name -VMSize $Size -AvailabilitySetId $AvailabilitySet.Id
        $VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $Name -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
        $VM = Add-AzVMNetworkInterface -VM $VM -Id $NIC.Id
        # $VM = Set-AzVMSourceImage -VM $VM -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter-Core' -Version latest
        $VM = Set-AzVMSourceImage -VM $VM -Id $ImageId

        # make VM
        New-AzVM -VM $VM -ResourceGroupName $ResourceGroupName -Location $Location -AsJob
    }

    do {
        $JobVMBuild = Get-Job | Where-Object {$_.State -eq 'Running'}
        Write-Verbose "Working..."
        Start-Sleep -Seconds 10
    } while ($JobVMBuild)
    Write-Verbose "Construction completed."
}