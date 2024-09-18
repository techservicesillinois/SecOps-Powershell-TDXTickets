<#
.Synopsis
    Gets a ticket.
.DESCRIPTION
    Gets a ticket.
.PARAMETER TicketID
    The ID of the Ticket.
.EXAMPLE
    Get-TDXTicket -TicketID '1394102'
#>
function Get-TDXTicket{
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}