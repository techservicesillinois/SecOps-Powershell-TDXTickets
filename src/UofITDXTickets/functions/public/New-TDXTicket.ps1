<#
.Synopsis
    Create a new TDX Ticket.
.DESCRIPTION
    Create a new TDX Ticket.
.PARAMETER NotifyRequestor
    When set to true, notifies the requestor of the ticket once the ticket has been created. Default is false.
.PARAMETER NotifyResponsible
    When set to true, notifies the responsible party of the ticket once the ticket has been created. Default is false.
.EXAMPLE
    New-TDXTicket # TODO
#>
function New-TDXTicket{
    [CmdLetBinding(DefaultParameterSetName="None")]
    param (
        [bool]$NotifyRequestor = $false,
        [bool]$NotifyResponsible = $false
    )

    process{
      
    }
}