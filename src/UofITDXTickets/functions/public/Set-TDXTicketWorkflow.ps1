<#
.Synopsis
    Assigns or reassigns a workflow to the ticket.
.DESCRIPTION
    Assigns or reassigns a workflow to the ticket.
.PARAMETER TicketID
    The ID of the Ticket.
.PARAMETER NewWorkflowID
    ID of the Workflow to assign the ticket to.
    This is the Int32 value of the workflow in TDX Admin, not the GUID value returned by Get-TDXTicketWorkflow.
.PARAMETER AllowRemoveExisting
    If this switch is specified, it allows an existing workflow to be removed to assign the new one.
    If this switch is not specified, and a workflow is already assigned, the new workflow will not be assigned.
.EXAMPLE
    Set-TDXTicketWorkflow -TicketID '1394102' -NewWorkflowID 355132
.EXAMPLE
    Set-TDXTicketWorkflow -TicketID '1394102' -NewWorkflowID 355132 -AllowRemoveExisting
#>
function Set-TDXTicketWorkflow{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [Int]$TicketID,
        [Parameter(Mandatory=$true)]
        [Int]$NewWorkflowID,
        [Switch]$AllowRemoveExisting
    )

    process{
        if ($PSCmdlet.ShouldProcess("Ticket ID: $($TicketID)/Workflow ID: $($NewSLAID)", "Sets Workflow for Ticket")){

            $RelativeUri = "$($Script:Settings.AppID)/tickets/$($TicketID)/workflow?newWorkflowId=$($NewWorkflowID)&allowRemoveExisting=$($AllowRemoveExisting)"
            
            $RestSplat = @{
                Method      = 'PUT'
                RelativeURI = $RelativeUri
            }

            $Response = Invoke-TDXRestCall @RestSplat
            $Response
        }
    }
}
