<#
.Synopsis
    Updates a ticket. 
.DESCRIPTION
    Updates a ticket. You can update status, add comments, and notify users at the same time using this function.
    To update custom attributes and other ticket details, use the Edit-TDXTicket function.
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER NewStatusID
    ID of the new status to set the ticket to.
    Use Get-TDXTicketStatuses to get the list of statuses.
.PARAMETER Comment
    Comment to add to the ticket.
.PARAMETER UsersToNotify
    Emails of the users to notify, provided as an array.
.EXAMPLE
    Update-TDXTicket -TicketID '1394102' -Comment 'This is a test comment'
.EXAMPLE
    Update-TDXTicket -TicketID '1394102' -Comment 'This is a test comment' -UsersToNotify @('buch1@illinois.edu')
.EXAMPLE
    Update-TDXTicket -TicketID '1394102' -Comment 'This is a test comment' -UsersToNotify @('buch1@illinois.edu') -NewStatusID 359
.EXAMPLE
    Update-TDXTicket -TicketID '1394102' -NewStatusID 359 -Comment 'Ticket status changed'
#>
function Update-TDXTicket{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Int]$NewStatusID,
        [Parameter(Mandatory=$true)]
        [String]$Comment,
        [String[]]$UsersToNotify
    )

    process{

        if ($PSCmdlet.ShouldProcess("Ticket ID: $($TicketID)/Status: $($NewStatusID)", "Updates Ticket")){

            $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/feed"

            $Body = @{
                'Comments' = $Comment
            }

            if ($NewStatusID) {
                $Body['NewStatusID'] = $NewStatusID
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
}
