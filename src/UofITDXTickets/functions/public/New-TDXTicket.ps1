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
    Use Get-TDXTicketTypes to get the list of types.
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
    You can get group IDs from Find-TDXGroups
.PARAMETER ResponsibleUid
    The UID of the responsible user associated with the ticket.
    You can get people UIDs from Find-TDXPeople
.PARAMETER ServiceID
    The ID of the service associated with the ticket.
.EXAMPLE
    New-TDXTicket -AccountID 7902 -PriorityID 24 -TypeID 345 -StatusID 357 -Title "Test Ticket" -RequestorUID "3c3caa7d-c365-ed11-ade6-0050f2e6378b" -Description "test ticket"
#>
function New-TDXTicket{
    [CmdletBinding(DefaultParameterSetName="None",SupportsShouldProcess)]
    param (
        [switch]$EnableNotifyReviewer,
        [switch]$AllowRequestorCreation,
        [switch]$NotifyRequestor,
        [switch]$NotifyResponsible,
        [switch]$ApplyDefaults,
        [Parameter(Mandatory=$true)]
        [int]$TypeID,
        [int]$FormID,
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [string]$Description,
        [switch]$IsRichHTML,
        [Parameter(Mandatory=$true)]
        [int]$AccountID,
        [int]$SourceID,
        [Parameter(Mandatory=$true)]
        [int]$StatusID,
        [Parameter(Mandatory=$true)]
        [int]$PriorityID,
        [DateTime]$GoesOffHoldDate,
        [Parameter(Mandatory=$true)]
        [string]$RequestorUID,
        [int]$ResponsibleGroupID,
        [string]$ResponsibleUID,
        [int]$ServiceID
    )

    process{
        if ($PSCmdlet.ShouldProcess("$($Title)", "Creates New Ticket")){
            $QueryObjects = @()
            $QueryParams = @('EnableNotifyReviewer', 'NotifyRequestor', 'NotifyResponsible', 'AllowRequestorCreation','applyDefaults') 
            $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { 
                if ($QueryParams -contains $_.Key) {
                    $QueryObjects += "$( $_.Key )=$( $_.Value )"
                }
            }

            $QueryString = $QueryObjects -join "&"
            $RelativeUri = "$($Script:Settings.AppID)/tickets?$($QueryString)"

            # Initialize the body array
            $Body = @{}

            # Iterate over all bound parameters, excluding the unique params, and params that don't belong in the body
            foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator()) {
                if ($param.Key -notin $QueryParams) {
                    $Body[$param.Key] = $param.Value
                }
            }

            $RestSplat = @{
                Method      = 'POST'
                RelativeURI = $RelativeUri
                Body        = $Body | ConvertTo-Json -Depth 3
            }

            $Response = Invoke-TDXRestCall @RestSplat
            $Response
        }
    }
}
