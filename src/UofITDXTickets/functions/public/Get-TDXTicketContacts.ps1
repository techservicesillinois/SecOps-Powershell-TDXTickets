<#
.Synopsis
    Gets the ticket contacts. 
.DESCRIPTION
    Gets the ticket contacts.
    Note: Contacts are not the same as Resources. Check the 'People' tab of the ticket to see the distinction. 
    For resources, use Get-TDXTicket and look at the 'Notify' property of the ticket. 
.PARAMETER TicketID
    The ID of the Ticket.
.EXAMPLE
    Get-TDXTicketContacts -TicketID '1394102'
#>
function Get-TDXTicketContacts{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/contacts"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
