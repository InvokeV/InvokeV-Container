Param($RootPath = "C:\")

Function Setup([String]$Drive, [String]$ScriptPath){
    If($RootPath.EndsWith("\") -eq $False){$RootPath += "\"}   
    Mkdir $env:USERPROFILE\Documents\WindowsPowerShell\Modules\InvokeVContainer -Force
    $Psm1 = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\InvokeVContainer\InvokeVContainer.psm1"
    Copy-Item ((Get-ChildItem $ScriptPath).DirectoryName + "\InvokeVContainer.psm1") -Destination $Psm1 -Force
    $Contents = Get-Content "$Psm1"
    $Contents = $Contents.Replace('<ROOT_PATH>',"$RootPath")
    $Contents > "$Psm1"
    Mkdir ($RootPath + "InvokeVContainer\Images") -Force
    Mkdir ($RootPath + "InvokeVContainer\Containers") -Force
    Remove-Module *
}

Setup $Drive $MyInvocation.MyCommand.Path | Out-Null
Write-Host "Setup Success!"



