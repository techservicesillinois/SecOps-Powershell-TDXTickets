<#
.Synopsis
    Gets the contents of an attachment.
.DESCRIPTION
    Gets the contents of an attachment.
.PARAMETER AttachmentID
    The ID of the Attachment. This can be found by inspecting the Attachments property returned by Get-TDXTicket.
.PARAMETER OutputPath
    The path to save the file attachment to.
.EXAMPLE
    Get-TDXTicketAttachmentContent -AttachmentID '888affd7-34f6-47d3-899e-79b2b45b59ff' -OutputPath 'C:\Temp\attachment.xlsx'
#>
function Get-TDXTicketAttachmentContent {
    param (
        [Parameter(Mandatory=$true)]
        [string]$AttachmentID,
        [Parameter(Mandatory)]
        [string]$OutputPath
    )
    process {

        New-TDXSession -Credential $TDXCredential
        $RestSplat = @{
            Headers = @{
                'Content-Type' = "application/json"
                'Authorization' = "Bearer $($Script:Session)"
            }
            Method = 'GET'
            URI = "https://help.uillinois.edu/TDWebApi/api/attachments/$($AttachmentID)/content"
            OutFile = $OutputPath
        }

        $Response = (Invoke-RestMethod @RestSplat)
        $Response
    }
}
