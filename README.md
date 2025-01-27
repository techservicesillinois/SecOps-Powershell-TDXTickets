![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-TDXTickets/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-TDXTickets/workflows/ScriptAnalyzer/badge.svg)

# What is This?

A Powershell wrapper for the TeamDynamix ticket API, allowing you to create scripts that run ticket operations tasks in TeamDynamix.

# How do I install it?

This will install the module on the local machine:
```Powershell
Install-Module -Name 'UofITDXTickets'
```

# How does it work?

After installing the module, you should set $env:TDXSettings to a JSON-formatted string containing BaseURI and AppID properties, for example:
```Powershell
$Env:Tdxsettings = '{ "BaseURI": ["https://help.uillinois.edu/TDWebApi/api/"], "AppID": ["01"] }'
```
Import the module using:
```Powershell
Import-Module -Name 'UofITDXTickets'
```
For a list of functions:
```Powershell
Get-Command -Module 'UofITDXTickets'
```
Get-Help is available for all functions in this module. For example:
```Powershell
Get-Help 'Update-TDXTicket' -Full
```

# How do I help?

Submit a pull request on GitHub.

# End-of-Life and End-of-Support Dates

As of the last update to this README, the expected End-of-Life and End-of-Support dates of this product are November 2026.

End-of-Life was decided upon based on these dependencies and their End-of-Life dates:

- Powershell 7.4 (November 2026)

# To Do

- Ticket Tasks functions https://help.uillinois.edu/TDWebApi/Home/section/TicketTasks
