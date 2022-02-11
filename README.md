This script is designed to run on a domain controller at a specified interval via scheduled tasks.
    This should be authenticated via service account as escalation is required!

The goal of this script is to assist an Active Directory environment that leverages a siem solution. As there is no natural generation of Event Logs for inactive user accounts over 'x' days without login, single pane management through the siem is not possible. This script runs passively on the DC and will generate the logs needed for your siem to gain visibility on this. (You likely will need to write your own parser for your siem to handle this log)
    
