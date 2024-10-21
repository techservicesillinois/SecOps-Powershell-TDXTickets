<#
.Synopsis
    Removes a contact from ticket.
.DESCRIPTION
    Removes a contact from ticket.
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER ContactUID
    The UID of the contact to remove.
    You can get this value from Get-TDXTicketContacts.
.EXAMPLE
    Remove-TDXTicketContact -TicketID '1394102' -ContactUID 'f85241a5-ac81-ed11-ac20-0050f2e67210'
#>
function Remove-TDXTicketContact{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [String]$ContactUID
    )

    process{

        if ($PSCmdlet.ShouldProcess("$($ContactUID)/$($TicketID)", "Delete Contact from Ticket")){

            $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/contacts/$($ContactUID)"

            $RestSplat = @{
                Method = 'DELETE'
                RelativeURI = $RelativeUri
            }

            $Response = Invoke-TDXRestCall @RestSplat
            $Response
        }
    }
}
