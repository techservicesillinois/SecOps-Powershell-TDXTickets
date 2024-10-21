<#
.Synopsis
    Gets a list of groups on search terms.
.DESCRIPTION
    Gets a list of groups on search terms.
.PARAMETER NameLike
    Text to search the group name for.
.PARAMETER HasAppID
    The App ID to search for groups in.
.EXAMPLE
    Find-TDXGroups -NameSearch 'UIUC-TechServices-Privacy and Cybersecurity Group'
#>
function Find-TDXGroups{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [String]$NameLike,
        [int]$HasAppID
    )

    process{

        $RelativeUri = "groups/search"

        $Body = @{}

        foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator()) {
            $Body[$param.Key] = $param.Value
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
