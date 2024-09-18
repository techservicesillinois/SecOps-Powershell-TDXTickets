<#
.Synopsis
    Gets the feed entries (comments) for a ticket.
.DESCRIPTION
    Gets the feed entries (comments, etc.) for a ticket.
.PARAMETER TicketID
    The ID of the Ticket.
.EXAMPLE
    Get-TDXTicketFeed -TicketID '1394102'
#>
function Get-TDXTicketFeed{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/feed"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}