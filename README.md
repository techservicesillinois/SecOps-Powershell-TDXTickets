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

Get-Help is available for all functions in this module.

# How do I help?

Submit a pull request on GitHub.

# To Do

- Remove-TDXTicketContact (prereq: Get-TDXPeople?)
- Add-TDXTicketContact (prereq: Get-TDXPeople?)
- Get-TDXTicketResource (custom functionality?)
- Get-TDXTicketSLAs
- Reports