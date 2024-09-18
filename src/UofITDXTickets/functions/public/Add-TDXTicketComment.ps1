<#
.Synopsis
    Updates a ticket with a feed entry (comment).
.DESCRIPTION
    Updates a ticket with a feed entry (comment).
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER Comment
    Comment to add to the ticket.
.PARAMETER UsersToNotify
    Emails of the users to notify, provided as an array.
.EXAMPLE
    Add-TDXTicketComment -TicketID '1394102' -Comment 'This is a test comment'
.EXAMPLE
    Add-TDXTicketComment -TicketID '1394102' -Comment 'This is a test comment' -UsersToNotify @('buch1@illinois.edu')
#>
function Add-TDXTicketComment{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [String]$Comment,
        [String[]]$UsersToNotify
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/feed"

        $Body = @{
            'Comments' = $Comment
        }
        
        if ($UsersToNotify) {
            $Body['Notify'] = $UsersToNotify
        }
        
        $RestSplat = @{
            Method      = 'POST'
            RelativeURI = $RelativeUri
            Body        = $Body | ConvertTo-Json
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
