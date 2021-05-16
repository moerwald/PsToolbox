
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "New-ServerGroup" {
    Describe "Export to global scope" {
        BeforeAll {
            $testsystem = New-ServerGroup -PathToConfigFile '..\ConfigSample\Config.xml'

        }

        Describe "Convert plain passwords to secure one" {

        }

        Describe "System object creation" {
            It "Number of servers is correct" {

            }

            It "Server has correct IP Address <IP>" -Foreach @(
                @{ IP = "10.0.0.3" }
                @{ IP = "10.0.0.4" }
                @{ IP = "10.0.0.5" }
                @{ IP = "10.0.0.6" }
            ) {

            }

        }

        Describe "Credential overrides" {

        }

    }
}