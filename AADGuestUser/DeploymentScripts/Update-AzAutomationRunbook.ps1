<# Note these commands are for the new Azure module AZ for Azure which is cross platform and replacing the Resource Manager commands
https://azure.microsoft.com/en-us/blog/azure-powershell-cross-platform-az-module-replacing-azurerm/
You can install the module via the PowerShell gallery: Install-Module AZ
The commands below will be similar if you are using the Resource Manager module, i.e AzSubscription = AzureRMSubscription

$subscription = ''
Connect-AzAccount
Select-AzSubscription -Subscription $subscription
#>

$resourceGroupName = ''
$automationAccountName = ''
$RunbookName = 'Send-MDAzureADGuestInvitation'
$scriptPath = './Send-MDAzureADGuestInvitation.ps1'
$tags = @{Environment = 'Production'; Description = 'Send invites to external users AAD and add to AAD group to allow access to application via MyApps'}

Import-AzAutomationRunbook -Path $scriptPath -Name $runbookName -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName -Type PowerShell -Tags $tags -Force
Publish-AzAutomationRunbook -Name $runbookName -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName
