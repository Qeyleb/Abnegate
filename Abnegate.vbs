' Abnegate: Qeyleb's all-in-one let's fix Windows Update reboot behavior in Windows 10.
' https://github.com/Qeyleb/Abnegate
' Version 0.1.0 last updated 2019/06/20

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

On Error Resume Next
Dim key : key = wshShell.RegRead("HKEY_USERS\S-1-5-19\Environment\TEMP")
'Check if elevated / administrator.  (Double-clicking the VBS does not elevate.)
If Err.Number <> 0 Then
	On Error GoTo 0
	MsgBox "Preparing to run as administrator.  Please click Yes on the next prompt."
	'Relaunch this very script, only elevated
	objShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """", "", "runas", 1
	WScript.Quit
End If

'Past this point it's definitely elevated.
'On Error GoTo 0

'Give updates for other Microsoft products than just Windows (Microsoft Update)
Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager")
ServiceManager.ClientApplicationID = "Microsoft Update"
Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

'Enable Windows Update Restart Notifications
RegPath = "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings\"
wshShell.RegWrite RegPath & "RestartNotificationsAllowed", 1, "REG_DWORD"

'Prevent auto reboot for Windows Updates
'Note: This will display "*Some settings are managed by your organization"
RegPath = "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\"
wshShell.RegWrite RegPath & "AUOptions", 3, "REG_DWORD"
wshShell.RegWrite RegPath & "NoAutoRebootWithLoggedOnUsers", 1, "REG_DWORD"
'Prevent Install Updates from taking over the Shutdown button
wshShell.RegWrite RegPath & "NoAUAsDefaultShutdownOption", 1, "REG_DWORD"
