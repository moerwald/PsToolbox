<#
.SYNOPSIS

Allows you to iterate over all servers in the server config.

.DESCRIPTION


.EXAMPLE

.EXAMPLE

#>

function Foreach-Server {
    [CmdletBinding()]
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
        [Parameter(Mandatory = $false, Position = 4)]
        # The message to show in the progress bar
        [string]
        $ProgressBarMessage = " ",
        # Activates progress bar
        [switch]
        $ShowProgressBar,
        # If set will rethrow catched exceptions
        [switch]
        $RethrowCatchedException
    )

    $filteredSystems = $ServerGroup.Systems.GetEnumerator() | Where-Object { $_.Key -like $ServerGroupName } 
    $filteredServers = @($filteredSystems.Value.Servers | Where-Object { 
        $ip = $_.IpAddress; $ServerNames | Where-Object { 
            $ip -like "*$_*"
        }
    })
    $count = $filteredServers.Count
    $index = 0
    foreach ($s in $filteredServers) {
        Write-Verbose "Working on server $($s.IpAddress)"

        if ($ShowProgressBar) {
            $index++
            Write-ProgressHelper -StepNumber $index -Steps  $count -Message ("[{0}]:{1}" -f $s.IpAddress, $ProgressBarMessage)
        }

        if (($s.PSSession -eq $false) -or ($s.PSSession.State -ne 'Opened')) {
            Write-Error "PSSession for server $($s.IpAddress) is not in opened state. Won't invoke command"
            continue
        }
        
        try {

            $lst = New-Object System.Collections.Generic.List[System.Management.Automation.PSVariable]
            $lst.Add((New-Object "PSVariable" @("_", $s)))
            $ScriptBlock.InvokeWithContext(@{ }, $lst)
        }
        catch {
            $errStr = "{0}`nStacktrace: {1}" -f $_, $_.ScriptStackTrace
            Write-Error $errStr
            if ($RethrowCatchedException) {
                throw $_
            }
        }
    }
}