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
function Add-TDXTicketAttachment{
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [String]$InputFilePath
    )

    process{
        
        # Encode file
        if($InputFilePath -like "*\*"){
            $FileName = $inputfilepath.Split('\')[-1]
        }
        elseif($InputFilePath -like "*/*"){
            $FileName = $inputfilepath.Split('/')[-1]
        }
        else{
            $FileName = $inputfilepath
        }
        $fileBytes = [System.IO.File]::ReadAllBytes("$($InputFilePath)");
        $fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes)
        $boundary = [System.Guid]::NewGuid().ToString()
        $LF = "`r`n"
        $bodyLines = ( 
            "--$boundary",
            "Content-Disposition: form-data; name=`"$($FileName)`"; filename=`"$($FileName)`"",
            "Content-Type: application/octet-stream$LF",
            $fileEnc,
            "--$boundary--$LF" 
        ) -join $LF

        # Make the REST API call (not using Invoke-TDXRestCall because of unique requirements)
        $IVRSplat = @{ 
            Headers = @{
                'Content-Type' = "multipart/form-data; boundary=`"$boundary`""
                'Authorization' = "Bearer $($Script:Session)"
            }
            Method = 'POST'
            URI = "https://help.uillinois.edu/TDWebApi/api/$($Script:Settings.AppID)/tickets/$($TicketID)/attachments"
        }
        $IVRsplat.add('Body', $BodyLines)
        $Attachment = Invoke-RestMethod @IVRSplat
        $Attachment
    }
}
