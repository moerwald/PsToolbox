<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE


#>

function New-ServerGroup {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript( { Test-Path $_ })]
        [string]
        $PathToConfigFile,

        # If the given config doesn't contain username and password, you can add via this parameter
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $CommonServerCredential,

        [switch]
        $DontExportAsGlobalObject
    )
    
    if ($global:ServerGroup) {
        # Remove old PsSession objects
        $sessions = @($Global:ServerGroups.ServerGroup.Values.Servers | `
                Select-Object -ExpandProperty PsSession | `
                Where-Object { $_ -ne $null })

        if ($sessions.Count -gt 0) {
            Remove-PSSession -Session $sessions -ErrorAction SilentlyContinue
        }
    }

    $xmlConfig = [xml] (Get-Content (Resolve-Path $PathToConfigFile).Path)

    $serverGroups = [PSCustomObject]@{
        Systems = @{}
    }

    foreach ($serverGroupsXml in $xmlConfig.Config.ServerGroups.ServerGroup) {
        $serverGroup = [PSCustomObject]@{
            Servers = @($serverGroupsXml.Servers.Server | ForEach-Object { 

                    # Create credential object for PS-remoting
                    [pscredential]$credObject = $CommonServerCredential
                    if (!($credObject)) {
                        if ($_.Credentials) {
                            $pwTemp = $_.Credentials.Password
                            $userTemp = $_.Credentials.UserName
                        }
                        else {
                            # If no local credential are given take the global ones
                            $pwTemp = $serverGroupsXml.Credentials.Password
                            $userTemp = $serverGroupsXml.Credentials.UserName
                        }

                        [securestring]$secStringPassword = ConvertTo-SecureString $pwTemp -AsPlainText -Force
                        [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userTemp, $secStringPassword)
                    }

                    $psSession = New-PSSession -ComputerName $_.IpAddress -Credential $credObject
                }
            )
        }
        
        $serverGroups.Systems[$serverGroupsXml.Name] = $serverGroup
        $serverGroups | Add-Member -NotePropertyName $serverGroupsXml.Name -NotePropertyValue $serverGroup
    }

    if ($DontExportAsGlobalObject -eq $false) {
        $global:ServerGroups = $serverGroups
    }
    $serverGroups
}