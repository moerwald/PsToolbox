<#
.SYNOPSIS


.EXAMPLE


.EXAMPLE

#>

function Foreach-ServerRemoteSession {
    [CmdletBinding(DefaultParameterSetName = "Parallel")]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        $ServerGroup = $Global:ServerGroup,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        $ServerGroupName = "*",
        # An array of server names
        [Parameter(Mandatory = $false, Position = 2)]
        [string[]]
        $ServerNames = @("*"),
        [Parameter(Mandatory = $true, Position = 3)]
        [scriptblock]
        $ScriptBlock,
        # Arguments to be injected in the param-block of $ScriptBlock
        [Parameter(Mandatory = $false, Position = 4)]
        [Object[]]
        $ArgumentList = @(),
        [Parameter(Mandatory = $false, Position = 5, ParameterSetName = "Sequential")]
        # The message to show in the progress bar
        [string]
        $ProgressBarMessage = " ",
        # Activates progress bar
        [Parameter(ParameterSetName = "Sequential")]
        [switch]
        $ShowProgressBar,
        # If set will rethrow catched exceptions
        [switch]
        $RethrowCatchedException,
        # If set will rethrow catched exceptions
        [Parameter(ParameterSetName = "Sequential")]
        [switch]
        $Sequential
    )
    $Script:sb = $ScriptBlock
    $Script:argList = $ArgumentList

    try {

        if (-not $Sequential) {
            $jobs = Foreach-Server `
                -ServerGroup $ServerGroup `
                $ServerGroupName $ServerGroupName `
                -ServerNames $ServerNames `
                -ProgressBarMessage $ProgressBarMessage `
                -ShowProgressBar:$ShowProgressBar `
                -RethrowCatchedException:$RethrowCatchedException `
                -ScriptBlock {
                Invoke-Command -Session $_.PsSession -ScriptBlock $Script:sb -ArgumentList $Script:argList -AsJob
            } 

            Wait-Job $jobs | Receive-Job 

            return
        }

        Foreach-Server `
            -ServerGroup $ServerGroup `
            $ServerGroupName $ServerGroupName `
            -ServerNames $ServerNames `
            -ProgressBarMessage $ProgressBarMessage `
            -ShowProgressBar:$ShowProgressBar `
            -RethrowCatchedException:$RethrowCatchedException `
            -ScriptBlock {
            Invoke-Command -Session $_.PsSession -ScriptBlock $Script:sb -ArgumentList $Script:argList
        } 
    }
    finally{
        Get-Job | Remove-Job
    }
}