<#
.Synopsis
    Gets all active ticket types within your TDX application.
.DESCRIPTION
    Gets all active ticket types within your TDX application.
.PARAMETER IncludeInactive
    Specify this switch to also return inactive ticket types.
.EXAMPLE
    Get-TDXTicketTypes
.EXAMPLE
    Get-TDXTicketTypes -IncludeInactive
#>
function Get-TDXTicketTypes{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [switch]$IncludeInactive
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/types"
        If($IncludeInactive){
            $RelativeUri += "?isActive=False"
        }

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
