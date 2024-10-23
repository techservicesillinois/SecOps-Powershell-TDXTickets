<#
.Synopsis
    Gets a list of tickets based on the specified parameters. Will not include full ticket information.
.DESCRIPTION
    Gets a list of tickets based on the specified parameters. Will not include full ticket information.
.PARAMETER MaxResults
    The maximum number of results to return.
.PARAMETER TicketID
    The ticket ID to filter on.
.PARAMETER SearchText
    The search text to filter on.
.PARAMETER FormIDs
    The form IDs to filter on.
.PARAMETER StatusIDs
    The status IDs to filter on.
.PARAMETER PriorityIDs
    The priority IDs to filter on.
.PARAMETER AccountIDs
    The account/department IDs to filter on.
.PARAMETER TypeIDs
    The ticket type IDs to filter on.
    Use Get-TDXTicketTypes to get the list of types.
.PARAMETER UpdatedDateFrom
    The minimum updated date to filter on.
.PARAMETER UpdatedDateTo
    The maximum updated date to filter on.
.PARAMETER UpdatedByUid
    The UID of the updating user to filter on.
.PARAMETER ModifiedDateFrom
    The minimum last modified date to filter on.
.PARAMETER ModifiedDateTo
    The maximum last modified date to filter on.
.PARAMETER ModifiedByUid
    The UID of the last modifying user to filter on.
.PARAMETER StartDateFrom
    The minimum start date to filter on.
.PARAMETER StartDateTo
    The maximum start date to filter on.
.PARAMETER EndDateFrom
    The minimum end date to filter on.
.PARAMETER EndDateTo
    The maximum end date to filter on.
.PARAMETER RespondedDateFrom
    The minimum responded date to filter on.
.PARAMETER RespondedDateTo
    The maximum responded date to filter on.
.PARAMETER RespondedByUid
    The UID of the responding user to filter on.
.PARAMETER ClosedDateFrom
    The minimum closed date to filter on.
.PARAMETER ClosedDateTo
    The maximum closed date to filter on.
.PARAMETER ClosedByUid
    The UID of the closing person to filter on.
.PARAMETER RespondByDateFrom
    The minimum SLA "Respond By" deadline to filter on.
.PARAMETER RespondByDateTo
    The maximum SLA "Respond By" deadline to filter on.
.PARAMETER CloseByDateFrom
    The minimum SLA "Resolve By" deadline to filter on.
.PARAMETER CloseByDateTo
    The maximum SLA "Resolve By" deadline to filter on.
.PARAMETER CreatedDateFrom
    The minimum created date to filter on.
.PARAMETER CreatedDateTo
    The maximum created date to filter on.
.PARAMETER CreatedByUid
    The UID of the creating user to filter on.
.PARAMETER DaysOldFrom
    The minimum age to filter on.
.PARAMETER DaysOldTo
    The maximum age to filter on.
.PARAMETER ResponsibilityUids
    The UIDs of the responsible users to filter on.
.PARAMETER ResponsibilityGroupIDs
    The IDs of the responsible groups to filter on.
    You can get group IDs from Find-TDXGroups
.PARAMETER PrimaryResponsibilityUids
    The UIDs of the primarily-responsible users to filter on.
.PARAMETER PrimaryResponsibilityGroupIDs
    The IDs of the primarily-responsible groups to filter on.
    You can get group IDs from Find-TDXGroups
.PARAMETER SlaIDs
    The SLA IDs to filter on.
.PARAMETER SlaViolationStatus
    The SLA violation status to filter on.
.PARAMETER AssignmentStatus
    The assignment status to filter on.
.PARAMETER RequestorUids
    The requestor UIDs to filter on.
.PARAMETER RequestorNameSearch
    The text to perform a LIKE search on the requestor's full name.
.PARAMETER RequestorEmailSearch
    The text to perform a LIKE search on the requestor's email address.
.PARAMETER IsOnHold
    The "On Hold" status to filter on.
.PARAMETER GoesOffHoldFrom
    The minimum "Goes Off Hold" date to filter on.
.PARAMETER GoesOffHoldTo
    The maximum "Goes Off Hold" date to filter on.
.EXAMPLE
    Find-TDXTicket -SearchText 'Test Ticket' -MaxResults 10
.EXAMPLE
    Find-TDXTicket -StatusIDs (1313,363) -MaxResults 10
.EXAMPLE
    Find-TDXTicket -ModifiedByUid (Find-TDXPeople -SearchText 'Tamara Buch').UID -MaxResults 10
.EXAMPLE
    # Gets 15 tickets created 14 days ago or later
    Find-TDXTicket -CreatedDateTo (Get-Date).AddDays(-14) -MaxResults 15
#>
function Find-TDXTicket{
    param (
        [Parameter(Mandatory=$true)]
        [Int]$MaxResults,
        [Int]$TicketID,
        [String]$SearchText,
        [Int[]]$FormIDs,
        [Int[]]$StatusIDs,
        [Int[]]$PriorityIDs,
        [Int[]]$AccountIDs,
        [Int[]]$TypeIDs,
        [DateTime]$UpdatedDateFrom,
        [DateTime]$UpdatedDateTo,
        [Guid]$UpdatedByUid,
        [DateTime]$ModifiedDateFrom,
        [DateTime]$ModifiedDateTo,
        [Guid]$ModifiedByUid,
        [DateTime]$StartDateFrom,
        [DateTime]$StartDateTo,
        [DateTime]$EndDateFrom,
        [DateTime]$EndDateTo,
        [DateTime]$RespondedDateFrom,
        [DateTime]$RespondedDateTo,
        [Guid]$RespondedByUid,
        [DateTime]$ClosedDateFrom,
        [DateTime]$ClosedDateTo,
        [Guid]$ClosedByUid,
        [DateTime]$RespondByDateFrom,
        [DateTime]$RespondByDateTo,
        [DateTime]$CloseByDateFrom,
        [DateTime]$CloseByDateTo,
        [DateTime]$CreatedDateFrom,
        [DateTime]$CreatedDateTo,
        [Guid]$CreatedByUid,
        [Int]$DaysOldFrom,
        [Int]$DaysOldTo,
        [Guid[]]$ResponsibilityUids,
        [Int[]]$ResponsibilityGroupIDs,
        [Guid[]]$PrimaryResponsibilityUids,
        [Int[]]$PrimaryResponsibilityGroupIDs,
        [Int[]]$SlaIDs,
        [Boolean]$SlaViolationStatus,
        [Boolean]$AssignmentStatus,
        [Guid[]]$RequestorUids,
        [String]$RequestorNameSearch,
        [String]$RequestorEmailSearch,
        [Boolean]$IsOnHold,
        [DateTime]$GoesOffHoldFrom,
        [DateTime]$GoesOffHoldTo
    )

    process{

        $RelativeUri = "$($Script:Settings.AppID)/tickets/search"

        # Initialize the body as an empty hashtable
        $Body = @{}

        # Loop through all bound parameters and add them to the body
        foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator()) {
            $Body[$param.Key] = $param.Value
        }

        $RestSplat = @{
            Method = 'POST'
            RelativeURI = $RelativeUri
            Body        = $Body | ConvertTo-Json
        }

        $Response = Invoke-TDXRestCall @RestSplat
        $Response
    }
}
