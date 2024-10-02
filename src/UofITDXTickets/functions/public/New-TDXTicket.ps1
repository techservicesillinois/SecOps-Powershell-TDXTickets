<#
.Synopsis
    Create a new TDX Ticket.
.DESCRIPTION
    Create a new TDX Ticket.
.PARAMETER EnableNotifyReviewer
    When set to true, notifies the reviewer of the ticket once the ticket has been created. Default is false.
.PARAMETER AllowRequestorCreation
    Whether a requestor should be created if an existing person with matching information cannot be found.
.PARAMETER ApplyDefaults
    Indicates whether or not to apply default values for properties that are not specified.
.PARAMETER NotifyRequestor
    When set to true, notifies the requestor of the ticket once the ticket has been created. Default is false.
.PARAMETER NotifyResponsible
    When set to true, notifies the responsible party of the ticket once the ticket has been created. Default is false.
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
.EXAMPLE
    New-TDXTicket # TODO
#>
function New-TDXTicket{
    [CmdletBinding(DefaultParameterSetName="None")]
    param (
        [bool]$EnableNotifyReviewer,
        [bool]$AllowRequestorCreation,
        [bool]$NotifyRequestor,
        [bool]$NotifyResponsible,
        [bool]$ApplyDefaults,
        #[Parameter(Mandatory=$true)]
        [int]$TypeID,
        [int]$FormID,
        #[Parameter(Mandatory=$true)]
        [string]$Title,
        [string]$Description,
        [switch]$IsRichHTML,
        #[Parameter(Mandatory=$true)]
        [int]$AccountID,
        [int]$SourceID,
        #[Parameter(Mandatory=$true)]
        [int]$StatusID,
        #[Parameter(Mandatory=$true)]
        [int]$PriorityID,
        [DateTime]$GoesOffHoldDate,
        #[Parameter(Mandatory=$true)]
        [string]$RequestorUID,
        [int]$ResponsibleGroupID,
        [string]$ResponsibleUID,
        [int]$ServiceID
    )

    process{
        $QueryObjects = @()
        $QueryParams = @('EnableNotifyReviewer', 'NotifyRequestor', 'NotifyResponsible', 'AllowRequestorCreation','applyDefaults') 
        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { 
            if ($QueryParams -contains $_.Key) {
                $QueryObjects += "$( $_.Key )=$( $_.Value )"
            }
        }

        $QueryString = $QueryObjects -join "&"
        $RelativeUri = "$($Script:Settings.AppID)/tickets?$($QueryString)"
        $RelativeUri
        # Initialize the body array
        # $body = ,@()

        # $ExcludedKeys = @('TicketID', 'NotifyNewResponsible', 'CustomAttributeIDs', 'CustomAttributeValues')

        # # Iterate over all bound parameters, excluding the unique params, and params that don't belong in the body
        # foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator()) {
        #     if ($param.Key -notin $ExcludedKeys) {
        #         # Prepare the "path" and "value" structure
        #         $path = "/$($param.Key)"
        #         $value = $param.Value
        #         # Convert boolean switch parameters to "true"/"false" strings
        #         if ($param.Value -is [switch]) {
        #             $value = $param.Value.ToString().ToLower()
        #         }
        #         # Add the JSON object to the body array
        #         $body += @{
        #             op    = 'add'
        #             path  = $path
        #             value = $value
        #         }
        #     }
        # }

        # # Handle Custom Attributes
        # if ($CustomAttributeIDs -and $CustomAttributeValues) {
        #     for ($i = 0; $i -lt $CustomAttributeIDs.Count; $i++) {
        #         $Body += @{
        #             'op'    = 'add'
        #             'path'  = "/attributes/$($CustomAttributeIDs[$i])"
        #             'value' = $CustomAttributeValues[$i]
        #         }
        #     }
        # }
        
        # $RestSplat = @{
        #     Method      = 'PATCH'
        #     RelativeURI = $RelativeUri
        #     Body        = $Body | ConvertTo-Json -Depth 3
        # }

        # $Response = Invoke-TDXRestCall @RestSplat
        # $Response
    }
}