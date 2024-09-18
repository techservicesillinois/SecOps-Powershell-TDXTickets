<#
.Synopsis
    Gets all active ticket statuses within your TDX application.
.DESCRIPTION
    Gets all active ticket statuses within your TDX application.
.EXAMPLE
    Get-TDXTicketStatuses
#>
function Get-TDXTicketStatuses{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/statuses"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}