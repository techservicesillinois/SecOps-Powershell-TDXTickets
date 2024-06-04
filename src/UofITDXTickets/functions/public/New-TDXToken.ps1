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

        # if ($PSCmdlet.ShouldProcess("$($Script:Settings.BaseURI)session/")){
            $Body = @{
                'username' = $Credential.UserName
                'password' = $Credential.GetNetworkCredential().Password
            }
            $IVRSplat = @{
                Headers = @{
                    'Content-Type' = 'application/json'
                }
                Method = 'POST'
                URI = "$($Script:Settings.BaseURI)auth/"
                Body = $Body | ConvertTo-Json
            }
            $Token = Invoke-RestMethod @IVRSplat
            if($Token){
                $Script:Session = $Token
            }
            else{
                throw $_
            }    
        # }
    }
}