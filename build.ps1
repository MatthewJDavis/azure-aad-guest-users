[cmdletbinding()]
param(
    [Validateset('Default', 'Analyse', 'Test')]
    [string[]]
    $Task = 'default'
)


if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -RequiredVersion 4.10.1 -Scope CurrentUser -Force }
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Scope CurrentUser -Force }
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force }

Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task -Verbose:$VerbosePreference
if ($psake.build_success -eq $false) { exit 1 } else { exit 0 }