$RootPath = "<ROOT_PATH>InvokeVContainer"

Function Import-ContainerImage($FilePath) { 
    $File = Get-ChildItem $FilePath
    If ($File.Extension -eq ".vhdx") {
        If ($File -match "[A-Fa-f0-9]{8}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{12}" -eq $True){
            Copy-Item $File -Destination ("$RootPath\Images\" + $File.Name)
        }Else{ 
            $ParentPath = (Get-VHD "$FilePath").ParentPath
            If ($ParentPath -eq ""){
                Copy-Item $File -Destination ("$RootPath\Images\" + $File.BaseName + "__" + [Guid]::NewGuid() + ".vhdx")
            }Else{
                $ParentID = (Get-ChildItem $ParentPath).BaseName.Split("_")[$ParentPath.Split("_").Length - 1]
                Copy-Item $File -Destination ("$RootPath\Images\" + $File.BaseName + "_" + $ParentID + "_" + [Guid]::NewGuid() + ".vhdx")
            }   
        }
    }Else{
        Expand-Archive -Path $FilePath -DestinationPath $RootPath\Images -Force
    } 
}

Function Export-ContainerImage([String]$ImageName, [String]$ExportPath, [Switch]$Tree){
    [Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" ) | Out-Null
    $Archive = [System.IO.Compression.ZipFile]::Open($ExportPath, "Update")
    $CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    $Image = Get-ChildItem (Get-ContainerImage | Where {$_.Name -eq "$ImageName"}).Path
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($Archive, $Image.FullName, $Image.Name, $CompressionLevel) | Out-Null  

    If($Tree){ 
        $ParentFile = (Get-ContainerImage | Where {$_.Name -eq "$ImageName"}).ParentPath  
        While ($ParentFile -ne ""){
            If($ParentFile -ne ""){
                [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($Archive, $ParentFile, (Get-ChildItem $ParentFile).Name, $CompressionLevel) | Out-Null
                $ParentFile = (Get-ContainerImage | Where {$_.Path -eq "$ParentFile"}).ParentPath
            }
        }        
    }
    $Archive.Dispose()
}

Function Get-InvokeVContanerRoot(){
     Return $RootPath
}

Function Correct-ContainerImage() { 
    $Images = Get-ChildItem -Path "$RootPath\Images" -Include "*.vhdx" -Recurse
    ForEach($Image in $Images){ 
        $ParentID = $Image.BaseName.Split("_")[ $Image.BaseName.Split("_").Length - 2]
        $Children = Get-ChildItem -Path "$RootPath\Images" -Include "*.vhdx" -Recurse | Get-VHD | Where {$_.ParentPath -Like "*$ParentID.vhdx"}
        ForEach($Child in $Children){ 
            $ParentFile = Get-ChildItem -Path "$RootPath\Images" | Where {$_.FullName -Like "*$ParentID.vhdx"}
            If($ParentID -ne "" ){                
                Write-Host ($Child.Path) ">" ($ParentFile.FullName)
                Set-VHD -Path $Child.Path –ParentPath $ParentFile.FullName -IgnoreIdMismatch                  
            }
        } 
    }
}

Function Merge-ContainerImage([String]$ImageName, [String]$NewImageName, [Switch]$Del) { 
    $ImagePath = (Get-ContainerImage | Where {$_.Name -eq "$ImageName"}).Path  
    $ParentPath = (Get-VHD "$ImagePath").ParentPath    
    $ParentID = $ParentPath.Split("_")[$ParentPath.Split("_").Length -2]
    $NewImageID = $NewImageName + "_" + $ParentID + "_" + [Guid]::NewGuid() 
    Copy-Item "$ParentPath" -Destination "$RootPath\Images\$NewImageID.vhdx" 
    Copy-Item "$ImagePath" -Destination "$RootPath\Images\$NewImageID.avhdx"
    Set-VHD -Path "$RootPath\Images\$NewImageID.avhdx" –ParentPath "$RootPath\Images\$NewImageID.vhdx"
    Merge-VHD –Path "$RootPath\Images\$NewImageID.avhdx" –DestinationPath "$RootPath\Images\$NewImageID.vhdx"  
    If($Del){ Remove-Item $ImagePath }        
    If($ParentID -ne "" ){ Merge-ContainerImage $NewImageName $NewImageName -Del }
}

Function Get-TreeView() { 
    $Global:Tree = "`r`n"
    $RootFiles = Get-ChildItem $RootPath\Images *.vhdx | Get-VHD | Where {$_.ParentPath -eq ""}
    ForEach($File in $RootFiles){ 
        Set-TreeView $File.Path 0    
    }
    Write-Host $Global:Tree
}

Function Set-TreeView([String]$ParentFile, [Int]$Level) { 
    $Files = Get-ChildItem -Path $RootPath -Include "*.vhdx" -Recurse | Get-VHD | Where {$_.ParentPath -eq $ParentFile} 
    $BaseName = (Get-ChildItem $ParentFile).BaseName
    $Names =$BaseName.Split("_")      
    If($Names.Length -eq 1){
        $Name = $BaseName
    }Else{
        $Name = $BaseName.Substring(0, ($BaseName.Length - ($Names[ $Names.Length - 1].Length +$Names[ $Names.Length - 2].Length) - 2))
    }    
    If((Get-ChildItem $ParentFile).FullName.ToUpper().StartsWith(("$RootPath\Images").ToUpper())){
        $Name = "[" + $Name + "]"
    }Else{
        $Name = " " + $Name    
    }
    $Space = ""
    For ( $i = 0; $i -lt (($Level - 1) * 12); $i++ ){ 
        $Space += " "
    }
    If($Level -ne 0){
        $Space += " |"
        For ( $i = 0; $i -lt (10 - $Nam.Length) ; $i++ ){ 
            $Space += "-"
        }
    }
    $Global:Tree += $Space + $Name +  "`r`n`r`n"
    If($Files.Count -eq 0){  
    }Else{    
        ForEach($File in $Files){     
            Set-TreeView $File.Path ($Level + 1)    
        }
    }
}

Function Get-ContainerImage { 
    Get-ChildItem $RootPath\Images *.vhdx | Where-Object {$_.Name -match "[A-Fa-f0-9]{8}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{4}\-[A-Fa-f0-9]{12}"} | Select `
    @{Label="Name"; Expression={($_.BaseName.Substring(0, $_.BaseName.Length - ($_.BaseName.Split("_")[$_.BaseName.Split("_").Length - 1].Length + $_.BaseName.Split("_")[$_.BaseName.Split("_").Length - 2].Length) - 2))}}, `
    @{Label="Path"; Expression={($_.FullName)}}, @{Label="Size(MB)"; Expression={($_.Length /1024/1024)}}, `
    @{Label="Created"; Expression={($_.LastWriteTime)}}, `
    @{Label="ParentPath"; Expression={(Get-VHD $_.FullName).ParentPath}} | Where-Object {$_.Name -ne ""}
}

Function New-ContainerImage([String]$ContainerName, [String]$ImageName) {
    $ParentNames = (Get-Container | Where {$_.Name -eq "$ContainerName"}).ParentPath.Split("_")
    $PID = ($ParentNames[$ParentNames.Length -1]).Split(".")[0]
    $ImageName = $ImageName + "_" + $PID + "_" + [Guid]::NewGuid() 
    $VM = Get-VM $ContainerName
    $Disk = Get-VMHardDiskDrive $VM   
    If($VM.State -eq "Off"){
        Get-VMHardDiskDrive $VM | Copy-Item -Destination "$RootPath\Images\$ImageName.vhdx"
     }Else{
        Checkpoint-VM $VM -SnapshotName "$ContainerName"
        Copy-Item (Get-VHD (Get-VMHardDiskDrive $VM).Path).ParentPath -Destination "$RootPath\Images\$ImageName.vhdx"
        Remove-VMSnapshot $VM –Name "$ContainerName" 
    }   
}

Function Remove-ContainerImage([String]$ImageName) { 
    $ImagePath = (Get-ContainerImage | Where {$_.Name -eq "$ImageName"}).Path 
    $Res = Get-ChildItem -Path "$RootPath" -Include "*.vhdx" -Recurse | Get-VHD | Where {$_.ParentPath -eq "$ImagePath"}
    If($Res.Count -eq 0){
        Remove-Item  $ImagePath -Recurse
    }Else{
        Write-Host """$ImageName"" is used other container images or containers." -ForegroundColor Red
    }
}

Function Get-Container { 
    Get-VM | Where-Object {Test-Path ("$RootPath\Containers\" + $_.Name)} | Select @{Label="Name"; Expression={$_.Name}}, State, @{Label="Path"; Expression={((Get-VMHardDiskDrive $_.Name | Where-Object {$_.ControllerLocation -eq 0}).Path)}}, @{Label="ParentPath"; Expression={(Get-VHD(Get-VMHardDiskDrive $_.Name | Where-Object {$_.ControllerLocation -eq 0}).Path).ParentPath}}
}

Function New-Container([String]$ContainerName, [String]$ImageName, [Long]$Memory=1024MB, [Int]$Processer=1, [String]$SwitchName) {
    $ImagePath = (Get-ContainerImage | Where {$_.Name -eq "$ImageName"}).Path 
    $VHD = New-VHD -Path "$RootPath\Containers\$ContainerName\$ContainerName.vhdx" -Differencing -ParentPath "$ImagePath"
    $VM = New-VM -Name "$ContainerName" -Generation 2 -MemoryStartupByte $Memory -VHDPath $VHD.Path -Path "$RootPath\Containers"
    Set-VM $VM -DynamicMemory -MemoryMaximumBytes $Memory -ProcessorCount $Processer
    If($SwitchName -ne ""){
        Get-VMNetworkAdapter $VM | Connect-VMNetworkAdapter –SwitchName $SwitchName
    }
    Set-VMFirmware $VM -EnableSecureBoot Off
    #Set-VMProcessor $VM -ExposeVirtualizationExtensions $True
} 

Function Remove-Container([String]$ContainerName) { 
    $VM = Get-VM "$ContainerName"
    If($VM.State -eq "Running"){
        Stop-VM $VM -TurnOff
    }  
    Remove-VM $VM -Force
    Remove-Item "$RootPath\Containers\$ContainerName" -Recurse
}

Function Start-Container([String]$ContainerName) {   
    Start-VM $ContainerName
}

Function Stop-Container([String]$ContainerName) {   
    Stop-VM $ContainerName -Force
}

Function Run-Container([String]$ContainerName, [String]$ImageName, [Long]$Memory=1024MB, [Int]$Processer=1, [String]$SwitchName, [String]$IPAddress, [String]$Subnet, [String]$Gateway, [String]$DNS = @()){
    New-Container -ContainerName "$ContainerName" -ImageName "$ImageName" -Memory $Memory -Processer $Processer -SwitchName "$SwitchName"
    Start-Container "$ContainerName"
    Wait-ContainerBoot "$ContainerName"
    Set-ContainerIPConfig -ContainerName "$ContainerName" -IPAddress $IPAddress -Subnet $Subnet -Gateway $Gateway -DNS $DNS
}

Function Set-ContainerIPConfig([String]$ContainerName, [String]$IPAddress = @(), [String]$Subnet = @(), [String]$Gateway = @(), [String]$DNS = @()){
    $ManagementService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService 
    $ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName = '$ContainerName'" 
    $SettingData = $ComputerSystem.GetRelated("Msvm_VirtualSystemSettingData") | Where-Object { $_.ElementName -eq "$ContainerName" }    
    $NetworkAdapters = $SettingData.GetRelated('Msvm_SyntheticEthernetPortSettingData') 
    $TargetNetworkAdapter = (Get-VMNetworkAdapter $ContainerName)[0] 
    $NetworkSettings = @()
    ForEach ($NetworkAdapter in $NetworkAdapters) {
        If ($NetworkAdapter.Address -eq $TargetNetworkAdapter.MacAddress) {
            $NetworkSettings = $NetworkSettings + $NetworkAdapter.GetRelated("Msvm_GuestNetworkAdapterConfiguration")
        }
    }
    $NetworkSettings[0].DHCPEnabled = $False
    $NetworkSettings[0].IPAddresses = $IPAddress
    $NetworkSettings[0].Subnets = $Subnet
    $NetworkSettings[0].DefaultGateways = $Gateway
    $NetworkSettings[0].DNSServers = $DNS
    $NetworkSettings[0].ProtocolIFType = 4096  
    $ManagementService.SetGuestNetworkAdapterConfiguration($ComputerSystem.Path, $NetworkSettings.GetText(1)) | Out-Null
    #Write-Host "IP was configured."
}
Function Wait-ContainerBoot([String]$ContainerName){
    $Flg = $False
    $TimeCount = 0
    Do
    { 
        If((Get-ContainerIPAddress $ContainerName) -ne ""){
            $Flg = $True 
        }Else{
            $TimeCount = $TimeCount + 1
            If($TimeCount -eq 180){
                 $Flg = $True 
            }
        }
        Start-Sleep -s 1
    }
    While ($Flg -eq $False)
}

Function Get-ContainerIPAddress([String]$ContainerName){
    $ManagementService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService 
    $ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName = '$ContainerName'" 
    $SettingData = $ComputerSystem.GetRelated("Msvm_VirtualSystemSettingData") | Where-Object { $_.ElementName -eq "$ContainerName" }    
    $NetworkAdapters = $SettingData.GetRelated('Msvm_SyntheticEthernetPortSettingData') 
    $TargetNetworkAdapter = (Get-VMNetworkAdapter $ContainerName)[0] 
    $NetworkSettings = @()
    ForEach ($NetworkAdapter in $NetworkAdapters) {
        If ($NetworkAdapter.Address -eq $TargetNetworkAdapter.MacAddress) {
            $NetworkSettings = $NetworkSettings + $NetworkAdapter.GetRelated("Msvm_GuestNetworkAdapterConfiguration")
        }
    }  
    If($NetworkSettings.Length -eq 0){
        Return ""
    }Else{
        If( $NetworkSettings[0].IPAddresses.Length -eq 0){
            Return ""
        }Else{
            Return $NetworkSettings[0].IPAddresses[0]    
        }        
    }
}









