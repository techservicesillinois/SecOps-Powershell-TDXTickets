<#
.Synopsis
    Updates a ticket. 
.DESCRIPTION
    Updates a ticket. You can edit most properties of a ticket using this function including custom attributes.
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER NotifyNewResponsible
    If this parameter switch is used, it will notify the newly-responsible resource(s) if the responsibility is changed as a result of the edit.
    Do not specify $true or $false, just use the switch.
.PARAMETER TypeID
    The ID of the ticket type associated with the ticket.
.PARAMETER FormID
    The ID of the form associated with the ticket.
    Use Get-TDXTicketForms to get the list of forms.
.PARAMETER Title
    The title of the ticket.
.PARAMETER Description
    The description of the ticket.
.PARAMETER IsRichHTML
    Indicates if the ticket description is rich-text or plain-text.
    Do not specify $true or $false, just use the switch.
.PARAMETER AccountID
    The ID of the account/department associated with the ticket.
.PARAMETER SourceID
    The ID of the ticket source associated with the ticket.
.PARAMETER StatusID
    The ID of the status associated with the ticket.
    Use Get-TDXTicketStatuses to get the list of statuses.
.PARAMETER PriorityID
    The ID of the priority associated with the ticket.
.PARAMETER GoesOffHoldDate
    The date the ticket goes off hold.
.PARAMETER RequestorUID
    The UID of the requestor associated with the ticket.
    You can get people UIDs from Find-TDXPeople
.PARAMETER ResponsibleGroupID
    The ID of the responsible group associated with the ticket.
.PARAMETER ResponsibleUid
    The UID of the responsible user associated with the ticket.
    You can get people UIDs from Find-TDXPeople
.PARAMETER ServiceID
    The ID of the service associated with the ticket.
.PARAMETER CustomAttributeIDs
    The IDs of custom attribute associated with the ticket.
.PARAMETER CustomAttributeValues
    The values to assign to the custom attributes, in respective order.
    For Choice attributes, these are Choice IDs, for people, these are Person UIDs, for Textboxes, you can submit any string.
.EXAMPLE
    Edit-TDXTicket -TicketID '1394102' -Title 'New Title' -Description '<b>New Description</b>' -IsRichHTML
.EXAMPLE
    Edit-TDXTicket -TicketID '1394102' -StatusID 360 -FormID 1074 -ResponsibleGroupID 787
.EXAMPLE
    Edit-TDXTicket -TicketID '1394102' -ResponsibleUid (Find-TDXPeople -SearchText 'Tamara Buch').UID -NotifyNewResponsible
.EXAMPLE
    Edit-TDXTicket -TicketID '1394102' -GoesOffHoldDate (Get-Date).AddDays(7)
.EXAMPLE
    Edit-TDXTicket -TicketID '1394102' -CustomAttributeIDs @('4362','5308','7718') -CustomAttributeValues @('8169','a3e79204-8fc9-ea11-a81d-000d3a8ea9f7','Text for textbox')
#>
function Edit-TDXTicket{
    param (
    [Parameter(Mandatory=$true)]
    [int]$TicketID,
    [switch]$NotifyNewResponsible,
    [int]$TypeID,
    [int]$FormID,
    [string]$Title,
    [string]$Description,
    [switch]$IsRichHTML,
    [int]$AccountID,
    [int]$SourceID,
    [int]$StatusID,
    [int]$PriorityID,
    [datetime]$GoesOffHoldDate,
    [string]$RequestorUID,
    [int]$ResponsibleGroupID,
    [string]$ResponsibleUid,
    [int]$ServiceID,
    [ValidateScript({
        if ($null -ne $CustomAttributeIDs -and $null -eq $CustomAttributeValues) {
            throw "If CustomAttributeIDs is provided, CustomAttributeValues must also be provided."
        }
        return $true
    })]
    [int[]]$CustomAttributeIDs,
    [string[]]$CustomAttributeValues
)

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)?notifyNewResponsible=$($NotifyNewResponsible)"

        # Initialize the body array
        $body = ,@()

        $ExcludedKeys = @('TicketID', 'NotifyNewResponsible', 'CustomAttributeIDs', 'CustomAttributeValues')

        # Iterate over all bound parameters, excluding the unique params, and params that don't belong in the body
        foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator()) {
            if ($param.Key -notin $ExcludedKeys) {
                # Prepare the "path" and "value" structure
                $path = "/$($param.Key)"
                $value = $param.Value
                # Convert boolean switch parameters to "true"/"false" strings
                if ($param.Value -is [switch]) {
                    $value = $param.Value.ToString().ToLower()
                }
                # Add the JSON object to the body array
                $body += @{
                    op    = 'add'
                    path  = $path
                    value = $value
                }
            }
        }

        # Handle Custom Attributes
        if ($CustomAttributeIDs -and $CustomAttributeValues) {
            for ($i = 0; $i -lt $CustomAttributeIDs.Count; $i++) {
                $Body += @{
                    'op'    = 'add'
                    'path'  = "/attributes/$($CustomAttributeIDs[$i])"
                    'value' = $CustomAttributeValues[$i]
                }
            }
        }
        
        $RestSplat = @{
            Method      = 'PATCH'
            RelativeURI = $RelativeUri
            Body        = $Body | ConvertTo-Json -Depth 3
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
