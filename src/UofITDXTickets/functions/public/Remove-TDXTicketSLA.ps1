<#
.Synopsis
    Removes the ticket's current service level agreement (SLA).
.DESCRIPTION
    Removes the ticket's current service level agreement (SLA).
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER Comment
    Comment to add to the ticket.
.PARAMETER UsersToNotify
    Emails of the users to notify, provided as an array.
.EXAMPLE
    Remove-TDXTicketSLA -TicketID '1394102'
.EXAMPLE
    Remove-TDXTicketSLA -TicketID '1394102' -Comment 'SLA Removed'
.EXAMPLE
    Remove-TDXTicketSLA -TicketID '1394102' -Comment 'SLA Removed' -UsersToNotify @('buch1@illinois.edu')
.EXAMPLE
    Remove-TDXTicketSLA -TicketID '1394102' -UsersToNotify @('buch1@illinois.edu')
#>
function Remove-TDXTicketSLA{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [String]$Comment,
        [String[]]$UsersToNotify
    )

    process{
        if ($PSCmdlet.ShouldProcess("$($TicketID)", "Delete SLA from Ticket")){
            $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/sla/delete"

            if ($Comment) {
                $Body = @{
                    'Comments' = $Comment
                }
            }
            Elseif ($UsersToNotify) {
                $Body = @{
                    'Notify' = $UsersToNotify
                }
            }

            if($Comment -and $UsersToNotify){
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
