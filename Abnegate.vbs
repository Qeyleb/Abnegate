' Abnegate: Qeyleb's all-in-one let's fix Windows Update reboot behavior in Windows 10.
' https://github.com/Qeyleb/Abnegate
' Version 0.2.0 last updated 2019-06-25

' We don't want Windows 10 to reboot while we're in the middle of stuff.  The objective is obvious but the solution is often misunderstood.
'  We don't want Windows 10 to reboot AT ALL until we're ready, so messing with Active Hours is an insufficient solution.
'  Instead we use a combination: if AUOptions is set to 3, this is "Notify Install", which means Windows will download the update,
'   BUT it will wait to install until the user clicks Install.
'  Combined with NoAutoRebootWithLoggedOnUsers, this means that until the user clicks Install, an update will never be installed 
'   and therefore never need to reboot!
'  I have tested this and left a computer unpatched and unrebooted for 6 months.  All other AUOptions settings didn't achieve this.

' With great power comes great responsibility: PATCH YOUR SYSTEMS.
' This is not an excuse to let your computers remain unpatched for months and months.
' Watch www.askwoody.com -- he gives a great general overview of patch reliability.  When MS-DEFCON goes down to 3 or 4, patch
'  and reboot as soon as convenient. 

Option Explicit

Dim wshShell : Set wshShell = CreateObject("WScript.Shell")
Dim objShell : Set objShell = CreateObject("Shell.Application")
Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")

If objFSO.FileExists(WScript.ScriptFullName & ":Zone.Identifier") Then
	'A Zone Identifier could mean the file is considered 'blocked' because it was downloaded.
	'Let's unblock it!  (same as the Unblock button found in File -> Properties)
	Dim objZoneFile : Set objZoneFile = objFSO.CreateTextFile(WScript.ScriptFullName & ":Zone.Identifier", True)
	objZoneFile.Close
End If

Dim strRegPath, intResult
strRegPath = "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\"

On Error Resume Next
If WScript.Arguments.Count > 0 Then
	'If there was an argument, it was probably passed from the unelevated version of this script. 
	intResult = CInt(WScript.Arguments(0))
ElseIf wshShell.RegRead(strRegPath & "AUOptions") = 3 Then
	If Err.Number = 0 Then
		'If this setting is already in place, we have probably run before, so ask.
		intResult = MsgBox("It looks like Abnegate settings have already been set." & vbCrLf &_
					"Uninstall/remove them?", vbYesNoCancel+vbQuestion, "Uninstall?")
		If intResult = vbCancel Then
			WScript.Echo "Cancelled. No changes were made."
			WScript.Quit
		End If
	Else
		'If this setting wasn't in place, looking for it caused an error, but that's fine.
		Err.Clear
		intResult = 0
	End If
Else
	intResult = 0
End If

Dim key : key = wshShell.RegRead("HKEY_USERS\S-1-5-19\Environment\TEMP")
'Check if elevated / administrator.  (Double-clicking the VBS does not elevate.)
If Err.Number <> 0 Then
	On Error GoTo 0
	WScript.Echo "Preparing to run as administrator.  Please click Yes on the next prompt."
	'Relaunch this very script, only elevated
	objShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ " & intResult, "", "runas", 1
	'Note that we're passing intResult as an argument so that the elevated script knows if we clicked Yes or No.
	WScript.Quit
End If

'Past this point it's definitely elevated.
On Error GoTo 0

'If Yes was clicked, we want to remove the registry settings.
If intResult = vbYes Then
	On Error Resume Next
	wshShell.RegDelete strRegPath & "AUOptions"
	wshShell.RegDelete strRegPath & "NoAUAsDefaultShutdownOption"
	wshShell.RegDelete strRegPath & "NoAutoRebootWithLoggedOnUsers"
	strRegPath = "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings\"
	wshShell.RegDelete strRegPath & "RestartNotificationsAllowed"
	wshShell.RegDelete strRegPath & "RestartNotificationsAllowed2"
	WScript.Echo "Abnegate settings have been removed."
	WScript.Quit
End If

'Past this point, we want to set the registry settings.
'Don't forget, strRegPath was already set earlier.

'Prevent auto reboot for Windows Updates
'Note: This will display "*Some settings are managed by your organization"
wshShell.RegWrite strRegPath & "AUOptions", 3, "REG_DWORD"
wshShell.RegWrite strRegPath & "NoAutoRebootWithLoggedOnUsers", 1, "REG_DWORD"
'Prevent Install Updates from taking over the Shutdown button
wshShell.RegWrite strRegPath & "NoAUAsDefaultShutdownOption", 1, "REG_DWORD"

'Enable Windows Update Restart Notifications
strRegPath = "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings\"
wshShell.RegWrite strRegPath & "RestartNotificationsAllowed", 1, "REG_DWORD"
wshShell.RegWrite strRegPath & "RestartNotificationsAllowed2", 1, "REG_DWORD"

'Give updates for other Microsoft products than just Windows (Microsoft Update)
Dim ServiceManager, NewUpdateService
Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager")
ServiceManager.ClientApplicationID = "Microsoft Update"
Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

WScript.Echo "Abnegate settings have been installed." & VbCr &_
             "You should see a note in Settings -> Update & Security:" & VbCr &_ 
			 "*Some settings are managed by your organization."
