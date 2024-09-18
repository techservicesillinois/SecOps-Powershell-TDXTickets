<#
.Synopsis
    Makes a REST method call on the given relative URI for TDX. Utilizes credentials created with New-TDXToken.
.DESCRIPTION
    Makes a REST method call on the given relative URI for TDX. Utilizes credentials created with New-TDXToken.
.PARAMETER RelativeURI
    The relativeURI you wish to make a call to. Ex: asset/ip/
.PARAMETER Method
    Method of the REST call Ex: GET
.PARAMETER Body
    Body of the REST call as a hashtable
.PARAMETER ContentType
    Content Type provided in the header. Default is application/json
.EXAMPLE
    $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)"
    $RestSplat = @{
        Method = 'GET'
        RelativeURI = $RelativeUri
    }
    Invoke-TDXRestCall @RestSplat
#>
function Invoke-TDXRestCall {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]$RelativeURI,
        [Parameter(Mandatory=$true)]
        [String]$Method,
        [hashtable]$Body
    )

    begin {
        if($null -eq $Script:Session){
            Write-Verbose -Message 'No TDX Token provided. Please provide TDX API credentials.'
            New-TDXSession
        }
    }

    process {

        if ($RelativeURI.StartsWith('/')){
            $RelativeURI.Substring(1)
        }

        $IVRSplat = @{
            Headers = @{
                'Content-Type' = 'application/json'
                'Authorization' = "Bearer $($Script:Session)"
            }
            Method = $Method
            URI = "$($Script:Settings.BaseURI)$RelativeURI"
        }
        if($Body){
            $IVRSplat.Add('Body', ($Body | ConvertTo-Json))
        }
        #Retry parameters only available in Powershell 7.1+, so we use a try/catch to retry calls once to compensate for short periods where the TDX api is unreachable
        try{
            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
        catch{
            Start-Sleep -Seconds 4
            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
    }
    end {
    }
}
