# azure-aad-guest-users
Automation of guest users in Azure

## Overview

Tools to automate the invitation of guest users to Azure AD using the [Azure b2b feature]

### Send-MDAzureADGuestInvitation.ps1

This PowerShell script should be run as an Azure Automation Runbook. It requires access to a CSV file that it can download from Azure blob storage.
The URI of the CSV should be saved as a secret in Azure Automation because it will contain the SAS token for access.

[Azure b2b feature]: https://docs.microsoft.com/en-us/azure/active-directory/b2b/what-is-b2b