<#
.SYNOPSIS
    Invite guest users to Azure Active Directory for demo application.
.DESCRIPTION
    Users to be provided in CSV file with the headings 'username,email'.
    Users will be be checked to see if they have been invited to Azure AD as a guest user previously. If there is already an invite, then no action will be take, if a user doesn't exist in Azure AD, then an invite will be sent.
    Output will be logged to the job output in Azure.
.NOTES
    https://docs.microsoft.com/en-us/azure/active-directory/b2b/b2b-quickstart-invite-powershell
#>

Import-Module -Name 'AzureAD'

$demoAppGroupId = ''
$TenantId = ''
$date = Get-Date -Format yyyy-MM-dd
$csvPath = "$env:tmp\test.csv"
$inviteCounter = 0
$csvUri = Get-AutomationVariable -Name 'demoApp-storage-sas'
$creds = Get-AutomationPSCredential -Name 'demoApp-invite-user'

try {
    Connect-AzureAD -Credential $creds | Out-Null
    Write-Output 'Connected to AzureAD'
}
catch {
    throw "Failed to connect to AzureAD: $_.Exception.Message"
}

#region get csv file
try {
    Invoke-WebRequest -Uri $csvUri -OutFile $csvPath
}
catch {
    throw "Failed to connect to download guest.csv file from demoAppstorage: $_.Exception.Message"
}
$userList = Import-Csv -Path $csvPath
#endregion

#region clean up userlist
# Some user emails from csv source have been internal ones ones (can not invite internal users as guests) or onmicrosoft so need to clean up
$cleanUserList = [collections.generic.list[psobject]]::new()

foreach ($user in $userList) {
    if ($user.email -like "*matthewdavis111*" -or $user.email -like "*#EXT#@matthewdavis111plcoutlook.onmicrosoft.com*") {
        Out-Null
    } else {
        $cleanUserList.Add($user)
    }
}
#endregion

$ExistingGuestUserList = Get-AzureADUser -All $true -Filter "userType eq 'Guest'"

foreach($user in $cleanUserList){
    $displayName = "$($user.username)"
    $url = "https://myapps.microsoft.com/?tenantid=$TenantId"

    # User has potentially been invited before, need to check
    if($user.email -in $ExistingGuestUserList.mail -or $user.email -in $ExistingGuestUserList.othermails) {
        Write-Output "User with email address already has been invited: $($user.email)"
    }
    else {
        try {
            $invite = New-AzureADMSInvitation -InvitedUserDisplayName $displayName -InvitedUserEmailAddress $user.email -SendInvitationMessage $true -InviteRedirectUrl $url
            Add-AzureADGroupMember -ObjectId $demoAppGroupID -RefObjectId $invite.InvitedUser.Id
            Write-Output "$($invite.InvitedUserEmailAddress) invited on $date. Added to demoApp AAD group."
            $inviteCounter ++
        }
        catch
        {
            Write-Output "Failed to send invite: $_.Exception.Message `n Failed to send invite to: $($user.email)"
        }
    }
}

$message =  "$($inviteCounter) new external user(s) invited to Azure AD to access demoApp."
Write-Output $message

Disconnect-AzureAD
Write-Output 'Finished runbook and disconnected from AzureAD'