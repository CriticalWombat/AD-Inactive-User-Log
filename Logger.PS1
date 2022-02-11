<#
.SYNOPSIS
	Run on a Windows Active Directory Domain Controller to find accounts that are enabled, but have not logged in for 90 or more days. Output to Windows Log (.evtx).
	This is designed to assist with siem visibility on inactive user accounts.
.DESCRIPTION
	Script will check the local machine for the proper logging sources and if not found it will create them under the 'Application' log with the source 'SIEM-PS-Script'
	Event ID produced is 65535
	Script enumerates all user accounts that are enabled, but haven't had a logon event in 90 or more days. Users that match this pattern are then named in the event log which will be collected and sent to the siem supervisor for visibility.
	A custom event parser will likely need to be written for your siem to handle these incoming logs.
.EXAMPLE
	Run the following line with escalation:
		New-EventLog -LogName "Application" -Source "SIEM-PS-Script
	Implement script in Task Scheduler
.NOTES
	Author:		Luke Von Hagel

	License:	This script is distributed under "THE BEER-WARE LICENSE" (Revision 42):
				As long as you retain this notice you can do whatever you want with this stuff.
				If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.

#>
#!!!MUST RUN THE LINE BELOW AS ADMIN BEFORE SCHEDULING THIS SCRIPT!!!#
#New-EventLog -LogName "Application" -Source "SIEM-PS-Script"

search-adaccount -accountinactive -usersonly -timespan "90" | Where-Object { $_.enabled } | select-object -property name, lastlogondate | Sort-Object -Property name, lastlogondate | ForEach-Object {
	$name = $_.name
	$date = $_.lastlogondate
	Write-EventLog -LogName "Application" -Source "SIEM-PS-Script" -EventId 65535 -EntryType Warning -Message "The following active directory user account is enabled, but has not signed in for 90 or more days!`n `nUsername: $name`nLastlogon: $date"
}