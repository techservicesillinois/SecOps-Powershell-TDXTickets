<#
.Synopsis
    Uploads an attachment to a ticket. The file should be included as part of the submission's form data.
.DESCRIPTION
    Uploads an attachment to a ticket. The file should be included as part of the submission's form data.
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER InputFilePath
    Full path of the file to be attached.
.EXAMPLE
    Add-TDXTicketAttachment -TicketID '1394102' -InputFilePath 'C:\temp\MyFile.xlsx'
#>
function Add-TDXTicketAttachment {
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [String]$InputFilePath
    )
    process {
        # Get filename from path
        if ($InputFilePath -like "*\*") {
            $FileName = $InputFilePath.Split('\')[-1]
        }
        elseif ($InputFilePath -like "*/*") {
            $FileName = $InputFilePath.Split('/')[-1]
        }
        else {
            $FileName = $InputFilePath
        }

        # Generate boundary for multipart form
        $boundary = [System.Guid]::NewGuid().ToString()
        $LF = "`r`n"

        # Create temporary memory stream to build the multipart form data
        $memStream = New-Object System.IO.MemoryStream
        $writer = New-Object System.IO.StreamWriter($memStream)

        # Write the form boundary
        $writer.Write("--$boundary$LF")
        $writer.Write("Content-Disposition: form-data; name=`"file`"; filename=`"$FileName`"$LF")
        $writer.Write("Content-Type: application/octet-stream$LF$LF")
        $writer.Flush()

        # Copy file contents directly as bytes
        $fileStream = [System.IO.File]::OpenRead($InputFilePath)
        $fileStream.CopyTo($memStream)
        $fileStream.Close()

        # Write closing boundary
        $writer.Write("$LF--$boundary--$LF")
        $writer.Flush()

        # Get the complete body as bytes
        $bodyBytes = $memStream.ToArray()
        $memStream.Close()

        # Make the REST API call
        $IVRSplat = @{
            Headers = @{
                'Content-Type' = "multipart/form-data; boundary=$boundary"
                'Authorization' = "Bearer $($Script:Session)"
            }
            Method = 'POST'
            URI = "https://help.uillinois.edu/TDWebApi/api/$($Script:Settings.AppID)/tickets/$($TicketID)/attachments"
            Body = $bodyBytes
        }

        $Attachment = Invoke-RestMethod @IVRSplat
        $Attachment
    }
}
