<#
.Synopsis
    Gets the currently assigned workflow details for a ticket.
.DESCRIPTION
    Gets the currently assigned workflow details for a ticket.
.PARAMETER TicketID
    The ID of the Ticket.
.EXAMPLE
    Get-TDXTicketWorkflow -TicketID '1394102'
#>
function Get-TDXTicketWorkflow{
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/workflow"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}