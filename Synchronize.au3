; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

Local Const $argLogin = "login"
Local Const $argLogout = "logout"

Local Const $titleNoDevice = "Az eszk�z nem tal�lhat�"
Local Const $titleArgMissing = "Hi�nyz� parancssori argumentum"
Local Const $titleNoSettings = "Nem tal�lhat� be�ll�t�sf�jl"

Local Const $messageNoDevice = "A szinkroniz�ci�hoz haszn�lt eszk�z nem tal�lhat�. A szinkroniz�ci� elkezd�s�hez csatlakoztassa az eszk�zt �s kattintson az Igen gombra vagy az eszk�z keres�s�nek �s a szinkroniz�ci� ideiglenes meg�ll�t�s�hoz a Nem gombra."
Local Const $messageArgMissing = "A felhaszn�l�nevet, az eszk�zc�m�t illetve a login vagy logout parancssori param�ter valamelyik�t meg kell adni"
Local Const $messageNoSettingsPrefix = "Az eszk�z�n nem tal�lhat� ehhez a sz�m�t�g�phez tartoz� be�ll�t�sf�jl. ("
Local Const $messageNoSettingsPostfix = ")"
Local Const $messageUsage = "Hasznalat: " & @ScriptFullPath & " felhasznalonev eszkozazonosito (login|logout)"

Func FindDeviceByLabel($deviceLabel)
	Local $drives = DriveGetDrive("ALL")
	Local $label
	For $i = 1 To $drives[0]
		SetError(0)
		$label = DriveGetLabel($drives[$i])
		If @error = 0 Then
			If $label == $deviceLabel Then
				Return $drives[$i]
			EndIf
		EndIf
	Next
	SetError(1)
EndFunc

Func FindSynchronizationDevice($requiredLabel)
	Do
		Local $device = FindDeviceByLabel($requiredLabel)
		Local $answer = 0
		If @error <> 0 Then
			$answer = MsgBox(4100, $titleNoDevice, $messageNoDevice)
		EndIf
	Until $device <> "" OR $answer <> 6
	Return $device
EndFunc

Local $device, $label, $user, $settingsFile, $action

If $CmdLine[0] <> 3 Or ($CmdLine[$CmdLine[0]] <> $argLogout And $CmdLine[$CmdLine[0]] <> $argLogin) Then
	ConsoleWrite($messageUsage)
	MsgBox(0, $titleArgMissing, $messageArgMissing)
	Exit(1)
EndIf

$user = $CmdLine[1]
$label = $CmdLine[2]
$action = $CmdLine[3]

If StringLower(@UserName) <> StringLower($user) Then
	Exit
EndIf

$device = FindSynchronizationDevice($label)
If $action = $argLogout Then
	$settingsFile  = $device & "\" & @ComputerName & "-" & $label & ".ffs_batch"
ElseIf $action = $argLogin Then
	$settingsFile = $device & "\" & $label & "-" & @ComputerName & ".ffs_batch"
EndIf

If $device <> "" Then
	If Not FileExists($settingsFile) Then
		MsgBox(4096, $titleNoSettings, $messageNoSettingsPrefix & $settingsFile & $messageNoSettingsPostfix)
	Else
		ShellExecuteWait("C:\Program Files\FreeFileSync\FreeFileSync.exe", $settingsFile);
	EndIf
EndIf