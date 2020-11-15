[cmdletbinding()]
param(
    [Validateset('Default', 'Analyse', 'Test')]
    [string[]]
    $Task = 'default'
)

$pesterVersion = '5.0.4'

if (!(Get-Module -Name Pester -ListAvailable).Version.ToString() -ne $pesterVersion) { 
    Install-Module -Name Pester -RequiredVersion $pesterVersion -Scope CurrentUser -Force
    Remove-Module -Name 'Pester' -Force
    Import-Module -Name 'Pester' -RequiredVersion $pesterVersion -Force
}
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Scope CurrentUser -Force }
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force }

Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task -Verbose:$VerbosePreference
if ($psake.build_success -eq $false) { exit 1 } else { exit 0 }