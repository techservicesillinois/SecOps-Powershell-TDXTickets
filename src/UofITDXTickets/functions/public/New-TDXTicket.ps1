#Create a new ticket
$EnableNotifyReviewer = $false
$NotifyRequestor = $false
$NotifyResponsible = $false
$AllowRequestorCreation = $false
$IVRSplat = @{
Headers = @{
'Content-Type' = 'application/json'
'Authorization' = "Bearer $($Token)"
}
Method = 'POST'
URI = "https://help.uillinois.edu/TDWebApi/api/$($AppID)/tickets?EnableNotifyReviewer=$($EnableNotifyReviewer)&NotifyRequestor=$($NotifyRequestor)&NotifyResponsible=$($NotifyResponsible)&AllowRequestorCreation=$($AllowRequestorCreation)"
}
$Body = @{
#Can GET from https://help.uillinois.edu/SBTDWebApi/api/accounts 'None/Not found' is what's being used
'AccountID' = 7902
'Title' = "API Test Ticket - $(Get-Date)"
# 'PriorityID' = 24
#Can GET from https://help.uillinois.edu/SBTDWebApi/api/$($AppID)/tickets/types 'UIUC-Privacy and Cybersecurity / Security Support' is what's being used
# 'TypeID' = 292
# 'RequestorUid' = $GUID
#Can GET from https://help.uillinois.edu/SBTDWebApi/api/$($AppID)/tickets/statuses 'New' is what's being used
'StatusID' = 357
} | ConvertTo-Json
$IVRsplat.add('Body', $Body)
$Response = Invoke-RestMethod @IVRSplat

$EnableNotifyReviewer = $false #This doesn't need to be a param
$NotifyRequestor = $false
$NotifyResponsible = $false
$AllowRequestorCreation = $false #This doesn't need to be a param
$AccountID # TODO make Get-TDXAccountIDs
$Title
$StatusID # TODO make Get-TDXStatusIDs
#OPTIONAL
$Description
$Requestor # TODO make Get-TDXUserGUIDs
$Priority # TODO make Get-TDXPriorityIDs 
$Type # TODO make Get-TDXTypeIDs 


﻿<#
.Synopsis
    Create a new TDX Ticket.
.DESCRIPTION
    Create a new TDX Ticket.
.PARAMETER Title
    The title of the Ticket.
.PARAMETER StatusID
    The ID of the status for the ticket. Status IDs can be found by using Get-TDXStatusIDs.
.PARAMETER AccountID
    The ID of the account for the ticket. Account IDs can be found by using Get-TDXAccountIDs.
.PARAMETER NotifyRequestor
    When set to true, notifies the requestor of the ticket once the ticket has been created. Default is false.
.PARAMETER NotifyResponsible
    When set to true, notifies the responsible party of the ticket once the ticket has been created. Default is false.
.PARAMETER Description
    Optional: Description of the ticket.
.PARAMETER RequestorGUID
    Optional: The GUID of the requestor. If not provided, the ticket will be created with no requestor. User GUIDs can be found by using Get-TDXUserGUIDs.
.PARAMETER PriorityID
    Optional: The ID of the priority for the ticket. Priority IDs can be found by using Get-TDXPriorityIDs.
.PARAMETER TypeID
    Optional: The ID of the type for the ticket. Type IDs can be found by using Get-TDXTypeIDs.
.EXAMPLE
    New-TDXTicket # TODO
#>
function New-TDXTicket{
    [CmdLetBinding(DefaultParameterSetName="None")]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Title,
        [Parameter(Mandatory=$true)]
        [Int]$StatusID,
        [Parameter(Mandatory=$true)]
        [Int]$AccountID,
        [bool]$NotifyRequestor = $false,
        [bool]$NotifyResponsible = $false,
        [String]$Description,
        [String]$RequestorGUID,
        [Int]$PriorityID,
        [Int]$TypeID
    )

    process{
        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'schedule/scan/'
            Body = @{
                action = 'create'
                echo_request = '1'
                scan_title = $Title
                default_scanner = [string][int]$DefaultScanners.IsPresent
                target_from = 'assets'
                observe_dst = 'yes'
                time_zone_code = 'US-IL'
            }
        }

        If($Daily){
            $RestSplat.Body['occurrence'] = 'daily'
            $RestSplat.Body['frequency_days'] = $Daily
        }

        If($Weekly){
            $RestSplat.Body['occurrence'] = 'weekly'
            $RestSplat.Body['frequency_weeks'] = $Weekly
            $RestSplat.Body['weekdays'] = $Weekdays
        }

        If($AssetGroups){
            If($AssetGroups[0] -match '\D'){
                $RestSplat.Body['asset_groups'] = (($AssetGroups).Trim() -join ",")
            }
            Else{
                $RestSplat.Body['asset_group_ids'] = (($AssetGroups).Trim() -join ",")
            }
        }

        If($OptionProfile){
            If($OptionProfile -match '\D'){
                $RestSplat.Body['option_title'] = $OptionProfile
            }
            Else{
                $RestSplat.Body['option_id'] = $OptionProfile
            }
        }

        If($Scanners){
            If($Scanners -match '\D'){
                $RestSplat.Body['iscanner_name'] = $Scanners
            }
            Else{
                $RestSplat.Body['iscanner_id'] = $Scanners
            }
        }

        If($FQDN){
            $RestSplat.Body['fqdn'] = (($FQDN).Trim() -join ",")
        }

        If($StartDate){
            $RestSplat.Body['start_date'] = $StartDate.ToString("MM/dd/yyyy")
        }

        If($Recurrence){
            $RestSplat.Body['recurrence'] = $Recurrence
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
        [String[]]$Exclusions = (
            'Daily','TimeZoneCode','Weekly','ExcludeIPs','DefaultScanners', 'AssetGroups',
            'OptionProfile', 'Scanners', 'FQDN', 'StartDate','Verbose', 'Recurrence'
        )
        $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
            if($MyInvocation.MyCommand.Parameters[$_].Aliases[0]){
                [String]$APIKeyNames = $MyInvocation.MyCommand.Parameters[$_].Aliases[0]
                $RestSplat.Body.$APIKeyNames = $PSBoundParameters[$_]
            }
            else {
                $RestSplat.Body.$_ = $PSBoundParameters[$_]
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        If($Response){
            Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
        }
    }
}