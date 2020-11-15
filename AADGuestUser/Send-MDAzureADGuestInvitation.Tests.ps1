BeforeAll {
    $sut = 'Send-MDAzureADGuestInvitation.ps1'
    $here = $PSScriptRoot
    # Create empty functions for cmdlets not on system to be mocked later
    function New-AzureADMSInvitation { }
    function Add-AzureADGroupMember { }
    function Get-AzureADUser { }
    function Get-AutomationPSCredential { }
    function Get-AutomationVariable { }
    function Connect-AzureAD { }
    function Disconnect-AzureAD { }
    function Import-Module { }

    Mock -CommandName 'Get-AutomationVariable' -MockWith {
        'https://test.com/'
    }
    Mock -CommandName 'Invoke-WebRequest' { }
    # mock csv data for passing to tests
    $mockCsv = [PSCustomObject]@{
        username = 'Bill Smith'
        email    = 'bill.smith@example.com'
    },
    [PSCustomObject]@{
        username = 'Frank White'
        email    = 'Frank.White@example.com'
    }
    $mockAzureADUser = [PSCustomObject]@{
        ObjectId          = 'ceda571c-7ca9-4eb4-be80-5dfc73595771'
        DisplayName       = 'Bill Smith'
        UserPrincipalName = 'bill.smith_example.com#EXT#@justeatplcoutlook.onmicrosoft.com'
        UserType          = 'Guest'
        Mail              = 'bill.smith@example.com'
    }
}
Describe "Users already existing in Azure AD" {
    BeforeEach {
        Mock -CommandName 'Import-Csv' -MockWith {
            $mockCsv[0]
        }
        Mock -CommandName 'Get-AzureADUser' -MockWith {
            $mockAzureADUser[0]
        }
        $result = . "$here\$sut"
    }
    It "Finds an existing guest user and does not send an invite" {
        $result[1] | Should -BeLike "User with email address already has been invited*"
    }
}
Describe "No users found in Azure AD with same email address" {
    BeforeEach {
        Mock -CommandName 'Import-Csv' -MockWith {
            $mockCsv[0]
        }
        Mock -CommandName 'Get-AzureADUser' -MockWith {
            $null
        }
        $result = . "$here\$sut"
    }
    It "Invites a new user" {
        $result[1] | Should -BeLike "*invited on*"
        function Disconnect-AzureAD { }
    }
    It "Invite count is 1" {
        $result[2] | Should -eq "1 new external user(s) invited to Azure AD to access demoApp."
    }
}
Describe "Two users exist in AzureAD, one needs to be invited" {
    BeforeEach {
        Mock -CommandName 'Import-Csv' -MockWith {
            $mockCsv
        }
    
        Mock -CommandName 'Get-AzureADUser' -MockWith {
            $mockAzureADUser[0]
        }
    
        $result = . "$here\$sut"
    }
    It "Finds an existing guest user and does not send an invite" {
        $result[1] | Should -Belike  "User with email address already has been invited*"
    }
    It "Invites a new user" {
        $result[2] | Should -BeLike "*invited on*"
    } 
    It "Invite count is 1" {
        $result[3] | Should -eq "1 new external user(s) invited to Azure AD to access demoApp."
    }
}
Describe "Two users needs to be invited" {
    BeforeEach {
        Mock -CommandName 'Import-Csv' -MockWith {
            [PSCustomObject]@{
                firstname = 'Bill'
                surname   = 'Smith'
                email     = 'bill.smith@ateam.com'
            },
            [PSCustomObject]@{
                firstname = 'Frank'
                surname   = 'White'
                email     = 'Frank.White@example.com'
            }
        }
        Mock -CommandName 'Get-AzureADUser' -MockWith {
            $null
        }
        $result = . "$here\$sut"
    }
    It "Invite count is 2" {
        $result[3] | Should -eq "2 new external user(s) invited to Azure AD to access demoApp."
    }
}