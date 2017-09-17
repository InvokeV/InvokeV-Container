Exit

#コマンド一覧
Get-Command -Module InvokeVContainer

#コンテナ作成
New-Container -ContainerName "C1" -ImageName "NanoIIS" -Memory 1024MB -Processer 1 -SwitchName "NAT"

Run-Container -ContainerName "C1" -ImageName "NanoIIS" -Memory 1024MB -Processer 1 -SwitchName "NAT" -IPAddress 172.16.0.1 -Subnet 255.255.255.240 -Gateway 172.16.0.254 -DNS 210.253.127.68

#コンテナIP設定
Set-ContainerIPConfig -ContainerName "C1" -IPAddress 172.16.0.1 -Subnet 255.255.255.240 -Gateway 172.16.0.254 -DNS 210.253.127.68

#コンテナに接続
vmconnect (hostname) "C1"

#コンテナ一覧
Get-Container

#コンテナ削除
Remove-Container "C1"

#コンテナ起動
Start-Container "C1"

#コンテナ停止
Stop-Container "C1"

#コンテナイメージ作成
New-ContainerImage -ContainerName "C1" -ImageName "IMG01"

#コンテナイメージのエクスポート
Export-ContainerImage  -ImageName "IMG01" -ExportPath "D:\InvokeVContainer\IMG01Exp.zip"

Export-ContainerImage  -ImageName "IMG01" -ExportPath "D:\InvokeVContainer\IMG01Exp.zip" -Tree

#コンテナイメージのインポート
Import-ContainerImage -FilePath "C:\Users\Administrator\Downloads\MyImage01.vhdx"

#コンテナイメージ削除
Remove-ContainerImage "IMG01"

#コンテナイメージ一覧
Get-ContainerImage

#コンテナイメージの結合
Merge-ContainerImage -ImageName "IMG01" -NewImageName "IMG_NanoIIS01"

#ツリー表示
Get-TreeView

#モジュール再読み込み
Remove-Module *
