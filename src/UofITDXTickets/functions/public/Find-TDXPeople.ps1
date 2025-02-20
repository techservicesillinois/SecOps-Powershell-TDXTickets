<#
.Synopsis
    Gets a list of users based on search terms. Will not return full user information.
.DESCRIPTION
    Gets a list of users based on search terms. Will not return full user information.
.PARAMETER SearchText
    Text to search all fields for. For most accurate results, use the UPN.
.EXAMPLE
    Find-TDXPeople -SearchText 'buch1@illinois.edu'
.EXAMPLE
    Find-TDXPeople -SearchText 'Tamara Buch'
#>
function Find-TDXPeople{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$SearchText
    )

    process{

        $RelativeUri = "people/search"

        $Body = @{
            'SearchText' = $SearchText
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
