﻿Import-Module -Force SalesforceCommerceCloudPowerShell,TervisSalesforceCommerceCloudPowerShell

Describe "TervisSalesforceCommerceCloudPowerShell" {
    It "Get-SCCOAuthAccessToken -GrantType APIClient" {
        $AccessToken = Get-SCCOAuthAccessToken -GrantType APIClient
        $AccessToken | Should -Not -BeNullOrEmpty
    }
    
    It "Get-SCCOAuthAccessToken -GrantType BusinessManagerUser" {
        $AccessToken = Get-SCCOAuthAccessToken -GrantType BusinessManagerUser
        $AccessToken | Should -Not -BeNullOrEmpty
    }
    
    It "Get-TervisSCCCustomerSearchResult" {
        Get-TervisSCCCustomerSearchResult -email arussell2@tervis.com | Should -Not -BeNullOrEmpty
    }

    It "Get-TervisSCCCustomer" {
        Get-TervisSCCCustomer -Email arussell2@tervis.com | Should -Not -BeNullOrEmpty
    }
}