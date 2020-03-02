# azure-aad-guest-users
Automation of guest users in Azure

[![Build Status](https://matthewjdavis111.visualstudio.com/azure-aad-guest-users/_apis/build/status/MatthewJDavis.azure-aad-guest-users?branchName=master)](https://matthewjdavis111.visualstudio.com/azure-aad-guest-users/_build/latest?definitionId=17&branchName=master)

## Overview

Tools to automate the invitation of guest users to Azure AD using the [Azure b2b feature]

### Send-MDAzureADGuestInvitation.ps1

This PowerShell script should be run as an Azure Automation Runbook. It requires access to a CSV file that it can download from Azure blob storage.
The URI of the CSV should be saved as a secret in Azure Automation because it will contain the SAS token for access.

### CI

Scripts for CI can be found in ci/scripts. These include running PSAnalyzer and Pester tests in a CI system such as Azure DevOps or Concourse

#### Tests

Test can be run via Invoke-Pester.

### Blog

Blog post on [sending invites].

### Diagram

![Diagram overview of solution](https://matthewdavis111.com/images/azuread-guest-invite/diagram.png)


[Azure b2b feature]: https://docs.microsoft.com/en-us/azure/active-directory/b2b/what-is-b2b
[sending invites]: https://matthewdavis111.com/azure/automating-azure-ad-guest-invites/
