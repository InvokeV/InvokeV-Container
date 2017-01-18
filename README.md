# InvokeV Container

InvokeV Container �͎g�����ꂽHyper-V��ŃR���e�i�Ɠ��l�ɁA��葬���A��菬��������������V�������z�}�V���̗��p���@���Ă��܂��B  

## �����F
* ���A�j������A�C���[�W�����čė��p�̃T�C�N�����ȒP�Ɏ����B
* �R���e�i���̂̃t�@�C����vhdx�̍����t�@�C���𗘗p���邱�Ƃōŏ����ɁB
* Windows�ANanoServer�ALinux�Ȃ�Hyper-V���T�|�[�g���Ă���OS�����p�\�B
* NanoServer�̃C���[�W�𗘗p���邱�ƂŁA��葬���A��菬�����������B
* Hyper-V��̃l�b�g���[�N�A�Z�L�����e�B�[�Ȃǉ��z�}�V���Ɠ��l�̎d�l�ŗ��p���\�B
* �����̉��z�}�V����Hyper-V��ō��ݗ��p���\�B
* �R���e�i�C���[�W�����g�ō쐬�B
* PowerShell�ƁAGUI�c�[���ł̊Ǘ����\�B
* �����[�g�f�X�N�g�b�v�ɂ��GUI���삪�\�B
* �e�̃R���e�i�C���[�W�Ƃ̌������ĐV�����C���[�W�Ƃ��ĕۑ����\�B
* Windows �R���e�i�ADocker�R���e�i�Ƃ͌݊����͂���܂���B


## �v���F
Windows Server 2016 Hyper-V  
Windows Server 2012 R2 Hyper-V  
  
  
## �C���X�g�[���F
 [InvokeVContainer.psm1](/InvokeVContainer.psm1) �� [Setup.ps1](/Setup.ps1) �𓯈�̃t�H���_�Ƀ_�E�����[�h���܂��B  
  
 �_�E�����[�h�����X�N���v�g�ŃZ�L�����e�B�[�x�����o��ꍇ������̂ŁA�X�N���v�g���A�����b�N���܂��B  
 
    PS C:\Users\Administrator\Downloads> Unblock-File .\Setup.ps1   
     
���|�W�g�����쐬����p�X���w�肵��Setup.ps1 �����s���܂��B  

    PS C:\Users\Administrator\Downloads> .\Setup.ps1 "D:\"

�w�肵���p�X�z���ɁuInvokeVContainer�v�t�H���_�i���̏ꍇ��D:\InvokeVContainer�j���쐬����AInvokeVContainer.psm1�t�@�C�����A�uC:\Users\Administrator\Documents\WindowsPowerShell\Modules\InvokeVContainer\InvokeVContainer.psm1�v�ɃR�s�[����܂��B�iAdministrator�Ń��O�C�����Ă���ꍇ�j  

��Windows�R���e�i�́uDocker-PowerShell�v��PowerShell���W���[�����C���X�g�[������Ă���ꍇ�́AUninstall-Module Docker ����сARemove-Module Docker�@�����s����Docker-PowerShell���폜����K�v������܂��B  
��InvokeVContainer.psm1�ɕύX���������ꍇ�́A�uRemove-Module *�v�����s���ă��W���[���̍ēǂݍ����K�v�ł��B  
���A���C���X�g�[���� ���|�W�g���t�H���_�ƁAInvokeVContainer.psm1���폜���܂��B  
  
  
## �R�}���h�̊m�F�F 

    > Get-Command -Module InvokeVContainer

    CommandType     Name                                               Version    Source                         
    -----------     ----                                               -------    ------                         
    Function        Correct-ContainerImage                             0.0        InvokeVContainer               
    Function        Export-ContainerImage                              0.0        InvokeVContainer               
    Function        Get-Container                                      0.0        InvokeVContainer               
    Function        Get-ContainerImage                                 0.0        InvokeVContainer               
    Function        Get-ContainerIPAddress                             0.0        InvokeVContainer               
    Function        Get-InvokeVContanerRoot                            0.0        InvokeVContainer               
    Function        Get-TreeView                                       0.0        InvokeVContainer               
    Function        Import-ContainerImage                              0.0        InvokeVContainer               
    Function        Merge-ContainerImage                               0.0        InvokeVContainer               
    Function        New-Container                                      0.0        InvokeVContainer               
    Function        New-ContainerImage                                 0.0        InvokeVContainer               
    Function        Remove-Container                                   0.0        InvokeVContainer               
    Function        Remove-ContainerImage                              0.0        InvokeVContainer               
    Function        Run-Container                                      0.0        InvokeVContainer               
    Function        Set-ContainerIPConfig                              0.0        InvokeVContainer               
    Function        Set-TreeView                                       0.0        InvokeVContainer               
    Function        Start-Container                                    0.0        InvokeVContainer               
    Function        Stop-Container                                     0.0        InvokeVContainer               
    Function        Wait-ContainerBoot                                 0.0        InvokeVContainer               
  
  
## �ŏ��̃R���e�i�C���[�W�F
�R���e�i�C���[�W�ƂȂ�̂́AOS���C���X�g�[���ς݂̉��z�}�V����vhdx�t�@�C���ł��B�C���[�W�Ƃ��ăC���|�[�g�����s���܂��B  

    > Import-ContainerImage -FilePath "D:\Hyper-V\Win2016\Win2016.vhdx"

vhdx�t�@�C����GUID�������Ă��t�@�C�����A�uD:\InvokeVContainer\Images�v�ɃR�s�[����܂��B�i�t�@�C���T�C�Y�ɂ���Ă͂��΂炭���Ԃ�������܂��B�j   
  
  
## �R���e�i�C���[�W�̊m�F�F

    > Get-ContainerImage

    Name       : IMG_01
    Path       : D:\InvokeVContainer\Images\IMG_01_2110bc02-d624-4c78-879b-dd6f5601fabc_1d0ac088-4547-4a49-bfa5-7f542e08a386.vhdx
    Size(MB)   : 1947
    Created    : 2017/01/16 21:49:01
    ParentPath : D:\InvokeVContainer\Images\Win2016__2110bc02-d624-4c78-879b-dd6f5601fabc.vhdx

    Name       : MyNewIMG_01
    Path       : D:\InvokeVContainer\Images\MyNewIMG_01__ac2e69c7-c406-42a3-a0a9-b7d6cbc8f116.vhdx
    Size(MB)   : 18308
    Created    : 2016/10/13 12:09:56
    ParentPath : 

    Name       : Win2016
    Path       : D:\InvokeVContainer\Images\Win2016__2110bc02-d624-4c78-879b-dd6f5601fabc.vhdx
    Size(MB)   : 18308
    Created    : 2016/10/13 12:09:56
    ParentPath : 
  
  
## �ŏ��̃R���e�i�̍쐬�F

    > New-Container -ContainerName "CON_01" -ImageName "Win2016" -Memory 2048MB -Processer 1 -SwitchName "NAT"

-SwithName�@�Ŏw�肷�鉼�z�X�C�b�`�͂��炩����Hyper-V�}�l�[�W���[�ō쐬�������̂��w�肵�Ă��܂��B  
New-NetNat�R�}���h�ō쐬����NAT���z�X�C�b�`�����p�ł��܂����AIP�A�h���X�͌ʂɊ��蓖�Ă�K�v������܂��B  

    > Run-Container -ContainerName "CON_01" -ImageName "Win2016" -Memory 2048MB -Processer 1 -SwitchName "NAT" -IPAddress 172.16.0.1 -Subnet 255.255.255.240 -Gateway 172.16.0.254 -DNS 8.8.8.8

Run-Container�R�}���h���g���ƁA�R���e�i�̍쐬�`�N���`IP�A�h���X�̐ݒ�܂ň�x�ɍs�����Ƃ��ł��܂��B  
��IP�A�h���X�̊����̓R���e�i�C���[�W��OS�������T�[�r�X�ɑΉ����Ă���ꍇ�̂݁B  �@
  
  
## �R���e�i�̊m�F�F


    > Get-Container

    Name     State Path                                              ParentPath                                                                   
    ----     ----- ----                                              ----------                                                                   
    CON_01 Running D:\InvokeVContainer\Containers\CON_01\CON_01.vhdx D:\InvokeVContainer\Images\Win2016__2110bc02-d624-4c78-879b-dd6f5601fabc.vhdx
  
  
## �R���e�i�̋N���F

    > Start-Container "CON_01" 
  
  
## �R���e�i�̒�~�F

    > Stop-Container "CON_01" 
  
  
## �R���e�i�ɐڑ��F

    > vmconnect (hostname) "CON_01" 

Hyper-V�}�l�[�W���[����Ɠ��l�ɁAvmconnext.exe �𗘗p���ăR���e�i�ɐڑ����܂��B  
    
  
## �ŏ��̃R���e�i�C���[�W�̍쐬�F

    > New-ContainerImage -ContainerName "CON_01" -ImageName "IMG_01" 

�쐬�����R���e�i����R���e�i�C���[�W���쐬���܂��B  
�R���e�i���N�����ł��A��~���ł��R���e�i�C���[�W���쐬���邱�Ƃ��\�ł��B  
�쐬���ꂽ�R���e�i�C���[�W�́A�R���e�i�̐e�C���[�W�t�@�C���̎q�t�@�C���i�����t�@�C���j�ƂȂ��Ă��܂��B  
�V�����쐬���ꂽ�R���e�i�C���[�W����A����ɃR���e���쐬�A�R���e�i�C���[�W���쐬�E�E�E  
  
  
## �R���e�i�C���[�W�̌����F

    > Merge-ContainerImage -ImageName "IMG_01" -NewImageName "MyNewIMG_01"
 
�e�q�֌W�̃R���e�i�C���[�W�t�@�C�����������āA�V�����R���e�i�C���[�W���쐬���܂��B  
�����O�̐e�q�t�@�C���͍폜���ꂸ�A�֘A�����R���e�i�����̂܂܎c����܂��B  
  
  
## �R���e�i�C���[�W�̍폜�F

    > Remove-ContainerImage "IMG_01"
  
  
## InvokeV Container Manager�F
[InvokeV Container Manager](/InvokeVContainerManager.exe) �́APowerShell�̃R�}���h��GUI���g���Ď��s���邱�ƂŁA���o�I�ɃR���e�i�̑���Ǘ����\�ƂȂ�܂��B  
�R���e�i�ł́A�t�@�C���̐e�q�֌W������ɂ킽�邽�߁A�\����c�����邽�߂ɂ��L�p�ȃc�[���ƂȂ��Ă��܂��B  
��{�I�ȑ���̓A�C�R�����}�E�X�̉E�N���b�N���Ă���n�߂�悤�ɂȂ��Ă��܂��B  
���Ǘ��Ҍ����ɂĎ��s����K�v������܂��B
![Invoke VContainer Manager](./images/cap.png "Invoke VContainer Manager")


## InvokeV Container Overview�F
[InvokeV Container Overview (YouTube)](https://youtu.be/FElIdcLgcdY)  