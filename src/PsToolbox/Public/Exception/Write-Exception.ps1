
function Write-Exception {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord = $Error[0]
    )

    $sb = [System.Text.StringBuilder]::new()

    $seperator = "=" * 40

    $sb.AppendLine() | Out-Null
    $sb.AppendLine("ScriptStackTrace:") | Out-Null
    $sb.AppendLine($seperator) | Out-Null
    $sb.AppendLine($ErrorRecord.ScriptStackTrace) | Out-Null
    $sb.AppendLine() | Out-Null

    $sb.AppendLine("Exception:") | Out-Null
    $sb.AppendLine($seperator) | Out-Null
    $sb.AppendLine($ErrorRecord.Exception) | Out-Null
    $sb.AppendLine("`tException.StackTrace:") | Out-Null
    $sb.AppendLine($ErrorRecord.Exception.StackTrace) | Out-Null

    $sb.AppendLine("InvocationInfo:") | Out-Null
    $sb.AppendLine($seperator) | Out-Null
    $sb.Append("`tMyCommand: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.MyCommand) | Out-Null
    $sb.Append("`tScriptName: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.ScriptName) | Out-Null
    $sb.Append("`tScriptLineNumber: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.ScriptLineNumber) | Out-Null
    $sb.Append("`tPSCommandPath: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.PSCommandPath) | Out-Null
    $sb.Append("`tInvocationName: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.InvocationName) | Out-Null
    $sb.Append("`tLine: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.Line) | Out-Null
    $sb.Append("`tPositionMessage: ") | Out-Null
    $sb.AppendLine($ErrorRecord.InvocationInfo.PositionMessage) | Out-Null

    Write-Host ($sb.ToString()) -ForegroundColor Red
}