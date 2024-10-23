<#
.Synopsis
    Gets information about a report, optionally including data.
.DESCRIPTION
    Gets information about a report, optionally including data.
.PARAMETER ReportID
    The ID of the report.
.PARAMETER WithData
    If specified, will populate the returned report's collection of rows.
.EXAMPLE
    Get-TDXReport -ReportID 6131
.EXAMPLE
    Get-TDXReport -ReportID 6131 -WithData
#>
function Get-TDXReport{
    param (
        [Parameter(Mandatory=$true)]
        [Int]$ReportID,
        [switch]$WithData
    )

    process{

        $RelativeUri = "/reports/$($ReportID)"

        if($WithData){
            $RelativeUri += '?withData=True'
        }

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
