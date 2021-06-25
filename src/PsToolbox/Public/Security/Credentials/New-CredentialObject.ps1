
function New-CredentialObject {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]
        $UserName,
        [ValidateNotNullOrEmpty()]
        [string]
        $Password
    )

    [SecureString]$secureString = $Password | ConvertTo-SecureString -AsPlainText -Force 
    New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $secureString
}