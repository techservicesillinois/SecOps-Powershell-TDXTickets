<#
.Synopsis
    Sets or changes the ticket's current service level agreement (SLA).
.DESCRIPTION
    Sets or changes the ticket's current service level agreement (SLA).
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER NewSLAID
    ID of the new SLA to set the ticket to.
.PARAMETER Comment
    Comment to add to the ticket.
.PARAMETER UsersToNotify
    Emails of the users to notify, provided as an array.
.EXAMPLE
    Set-TDXTicketSLA -TicketID '1394102' -NewSLAID 60
.EXAMPLE
    Set-TDXTicketSLA -TicketID '1394102' -NewSLAID 60 -Comment 'SLA Changed to Test SLA'
.EXAMPLE
    Set-TDXTicketSLA -TicketID '1394102' -NewSLAID 60 -Comment 'SLA Changed to Test SLA' -UsersToNotify @('buch1@illinois.edu')
.EXAMPLE
    Set-TDXTicketSLA -TicketID '1394102' -NewSLAID 60 -UsersToNotify @('buch1@illinois.edu')
#>
function Set-TDXTicketSLA{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [Int]$NewSLAID,
        [String]$Comment,
        [String[]]$UsersToNotify
    )

    process{
        if ($PSCmdlet.ShouldProcess("Ticket ID: $($TicketID)/SLA ID: $($NewSLAID)", "Sets SLA for Ticket")){
            $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/sla"

            $Body = @{
                'NewSlaID' = $NewSLAID
            }

            if ($Comment) {
                $Body['Comments'] = $Comment
            }

            if ($UsersToNotify) {
                $Body['Notify'] = $UsersToNotify
            }

            $RestSplat = @{
                Method      = 'PUT'
                RelativeURI = $RelativeUri
                Body        = $Body | ConvertTo-Json
            }

            $Response = Invoke-TDXRestCall @RestSplat
            $Response
        }
    }
}
