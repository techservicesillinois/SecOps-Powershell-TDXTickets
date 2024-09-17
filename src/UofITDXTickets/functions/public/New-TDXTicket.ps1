<#
.Synopsis
    Create a new TDX Ticket.
.DESCRIPTION
    Create a new TDX Ticket.
.PARAMETER Title
    The title of the Ticket.
.PARAMETER StatusID
    The ID of the status for the ticket. Status IDs can be found by using Get-TDXStatusIDs.
.PARAMETER AccountID
    The ID of the account for the ticket. Account IDs can be found by using Get-TDXAccountIDs.
.PARAMETER NotifyRequestor
    When set to true, notifies the requestor of the ticket once the ticket has been created. Default is false.
.PARAMETER NotifyResponsible
    When set to true, notifies the responsible party of the ticket once the ticket has been created. Default is false.
.PARAMETER Description
    Optional: Description of the ticket.
.PARAMETER RequestorGUID
    Optional: The GUID of the requestor. If not provided, the ticket will be created with no requestor. User GUIDs can be found by using Get-TDXUserGUIDs.
.PARAMETER PriorityID
    Optional: The ID of the priority for the ticket. Priority IDs can be found by using Get-TDXPriorityIDs.
.PARAMETER TypeID
    Optional: The ID of the type for the ticket. Type IDs can be found by using Get-TDXTypeIDs.
.EXAMPLE
    New-TDXTicket # TODO
#>
function New-TDXTicket{
    [CmdLetBinding(DefaultParameterSetName="None")]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Title,
        [Parameter(Mandatory=$true)]
        [Int]$StatusID,
        [Parameter(Mandatory=$true)]
        [Int]$AccountID,
        [bool]$NotifyRequestor = $false,
        [bool]$NotifyResponsible = $false,
        [String]$Description,
        [String]$RequestorGUID,
        [Int]$PriorityID,
        [Int]$TypeID
    )

    process{
      
    }
}