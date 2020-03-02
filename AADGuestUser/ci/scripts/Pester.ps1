if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Scope CurrentUser -Force }

$testResults = Invoke-Pester -Path '../../Send-MDAzureADGuestInvitation.Tests.ps1' -PassThru
        if ($testResults.FailedCount -gt 0) {
            $testResults | Format-List
            Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
        }