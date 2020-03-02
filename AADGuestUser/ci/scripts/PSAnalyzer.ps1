if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force }

Invoke-ScriptAnalyzer -Path '../../Send-MDAzureADGuestInvitation.ps1' -Severity Warning