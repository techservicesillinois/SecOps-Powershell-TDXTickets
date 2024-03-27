<#
.Synopsis
   This function creates a TDX authentication token to be used with the other functions in this module.
.DESCRIPTION
   This function creates a TDX authentication token to be used with the other functions in this module.
.PARAMETER Credential
    Credentials used to authenticate to the TDX API
.EXAMPLE
    $Credential = Get-Credential
    New-TDXToken -Credential $Credential
#>
function New-TDXToken{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{

        if ($PSCmdlet.ShouldProcess("$($Script:Settings.BaseURI)session/")){
            $IVRSplat = @{
                Headers = @{
                    "X-Requested-With"="powershell"
                }
                Method = 'POST'
                URI = "$($Script:Settings.BaseURI)session/"
                Body = @{
                    action = "login"
                    username = $Credential.UserName
                    password = $Credential.GetNetworkCredential().Password
                }
                SessionVariable = 'Cookie'
            }

            Write-Verbose -Message "Generating Qualys API cookie for $($Credential.UserName)"
            $Response = Invoke-RestMethod @IVRSplat
            if( $Response.SIMPLE_RETURN.RESPONSE.TEXT -eq 'Logged in' ){
                $Script:Session = $Cookie
            }
            else{
                Throw $Response.SIMPLE_RETURN.RESPONSE.TEXT
            }
        }
    }
}