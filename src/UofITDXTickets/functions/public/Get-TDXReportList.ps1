<#
.Synopsis
    Gets a list of all Report Builder reports visible to the user.
.DESCRIPTION
    Gets a list of all Report Builder reports visible to the user.
.EXAMPLE
    Get-TDXReportList
#>
function Get-TDXReportList{

    process{

        $RelativeUri = "/reports"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
