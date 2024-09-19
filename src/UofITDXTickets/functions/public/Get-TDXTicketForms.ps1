<#
.Synopsis
    Gets all active ticket forms within your TDX application.
.DESCRIPTION
    Gets all active ticket forms within your TDX application.
.EXAMPLE
    Get-TDXTicketForms
#>
function Get-TDXTicketForms{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/forms"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}