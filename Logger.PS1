<#
.SYNOPSIS
	Run on a Windows Active Directory Domain Controller to find accounts that are enabled, but have not logged in for 90 or more days. Output to Windows Log (.evtx).
.DESCRIPTION

.EXAMPLE
	.\Logger.ps1
	Likely to be implemented in Task Scheduler
.NOTES
	Author: 			Luke Von Hagel (lvonhagel@brashbit.io)

	License:			This script is distributed under "THE BEER-WARE LICENSE" (Revision 42):
						As long as you retain this notice you can do whatever you want with this stuff.
						If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.

#>

$users = search-adaccount -accountinactive -usersonly -timespan "90" | where { $_.enabled } | select-object -property name, lastlogondate | Sort-Object -Property lastlogondate, name
$users | ForEach-Object {
	New-Event -LogName "Dormant Users (90 days)"
	Write-EventLog -LogName "Dormant Users (90 days)" -EventId 65535 -EntryType Information -Message "The following user account is enabled, but has not signed in for 90 or more days!`n `n $_ "
}