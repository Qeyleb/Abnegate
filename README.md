# Contents
  - [Description](#description)
  - [Removal](#removal)
  - [FAQ](#faq)
  - [Advanced](#advanced)
  - [License](#license)
  - [Disclaimer](#disclaimer)

## Description
Abnegate is a script that will apply a combination of tweaks that will prevent Windows Update from rebooting your machine without your consent.

"I abnegate Windows Update's automatic updates and reboots!"

## Usage
If you just want to go ahead and run it, simply double-click **Abnegate.vbs** -- you will need to then confirm the User Account Control prompt as it will attempt to run itself with elevated privileges.<br>

From then on, Windows Update will not automatically install updates, but instead notify you when there are updates ready to install.  It's up to you to click "Install".  Go to Settings, then Update & Security.

With great power comes great responsibility: *PATCH YOUR SYSTEMS.*  This is not an excuse to let your computers remain unpatched for months and months.  I have given you the power to reboot on your own terms.  Check for updates and install them when convenient.

Warning: if you're at work, you should probably ask your IT department before you mess with something like this.

For more explanation of how this works, see [Advanced](#advanced).

## Removal
Run it again.  It will detect if the settings are in place and prompt whether you want to uninstall.

Note: It can't detect what your old settings were, so it'll go back to Windows defaults.

## FAQ

**Q:** Should I just go ahead and run the script?<br>
**A:** You can, if you're ok with the responsibility of installing Windows Updates yourself.  Don't say I didn't warn you if you leave your machine unpatched for months and then get exploited.

**Q:** What versions of Windows will it work on?<br>
**A:** I have tested it on many different versions of Windows 10, most recently 1709, 1803, 1809, and 1903.  As for editions, I've tested Enterprise, Education, and Professional.  In theory it should work on all versions of Windows 10, but maybe not the Home edition.  And of course Windows 7 and 8.x never had this problem.

**Q:** Do you use this yourself?<br>
**A:** Yes, on all my personal computers.  I also test it on quite a few different virtual machines.  I'm planning to use it at my job if allowed.

**Q:** I can't get this to work.  Windows still rebooted.<br>
**A:** Is that a question?  But seriously, is your edition Windows 10 Home?  If so this may not work.  I haven't fully tested it though.  Let me know.

**Q:** Nothing happened.<br>
**A:** If you open Settings -> Update & Security, you should see "\*Some settings are managed by your organization".  If not, let me know.  You do need to be able to elevate to administrator when prompted; if you can't, this will not work for you.

**Q:** This actually broke my computer and I'm mad.<br>
**A:** What?  I'm not doing anything destructive.  Still, contact me and let me know your problem.  I take no responsibility or liability, but I will be glad to give suggestions.

**Q:** VBScript?  Why?<br>
**A:** Why not?  It works, it's less fiddly to get running than PowerShell, and it's more flexible than a plain .reg file.

**Q:** Can I change it and use it for my own purposes?<br>
**A:** Please do!  See [License](#license).  Do me a favor and let me know what you end up making, I'd like to know how people use it.  I would be glad to make changes to better fit others, as well.

## Advanced
We don't want Windows 10 to reboot while we're in the middle of stuff.  The objective is obvious but the solution is often misunderstood.

We don't want Windows 10 to reboot AT ALL until we're ready, so messing with Active Hours is an insufficient solution.

Instead we use a little-known behavior of a specific setting/policy, known as "Configure the behavior of the Automatic Updates service", or AUOptions.  If it is set to 3, this is "Notify Install", which means Windows will download the update, BUT it will wait to install until the user clicks Install.

This means DON'T click Install until you're ready to reboot.  Until you click it, an update will never be installed and therefore never need to reboot!

I have tested this and left a computer unpatched and unrebooted for 6 months.  All other Windows Update settings didn't achieve this.

With great power comes great responsibility: *PATCH YOUR SYSTEMS.*  This is not an excuse to let your computers remain unpatched for months and months.  I have given you the power to reboot on your own terms.

Watch [www.askwoody.com](https://www.askwoody.com) -- he gives a great general overview of patch reliability.  When his MS-DEFCON goes down to 3 or 4, patch and reboot as soon as convenient.

## License
MIT License -- See [LICENSE.md](LICENSE.md)<br>
I also ask nicely that you let me know what you think, especially if you use ideas from or modify any of the files.

## Disclaimer
I take no responsibility or liability for anything this does to your computer that you did or didn't want.  It's all open source so look at it first before using it; if you have questions, ask.<br>
I intend no harm; I make a useful thing for myself, and share it here that others may or may not find useful.  I've done my best to test this on all common configurations and I use it myself.  But computers can be unpredictable and Windows changes, so there's always the possibility of unintended behavior.<br>
Still, if something goes wrong I want to learn about it, and may offer help as well, so contact me and let me know your problem.  I will be glad to give suggestions.
