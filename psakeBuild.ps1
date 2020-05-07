Task default -depends Analyse, Test

Task Analyse -description 'Analyse script with PSScriptAnalyzer' {
    $saResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\AADGuestUser\Send-MDAzureADGuestInvitation.ps1 -Severity @('Error', 'Warning')
    if ($saResults) {
        $saResults | Format-Table
        Write-Error -Message 'One or more Script Analyser errors/warnings were found'
    }
}

Task Test -description 'Run Pester tests ' {
    $testResults = Invoke-Pester -Path $PSScriptRoot\AADGuestUser\ -PassThru
    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error  -Message 'One or more pester test failed!'
    }
}
