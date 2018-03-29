Import-Module -Force TervisSalesforceCommerceCloudPowerShell

Describe "TervisSalesforceCommerceCloudPowerShell" {
    It "Get-SCCOAuthAccessToken" {
        $AccessToken = Get-SCCOAuthAccessToken 
        $AccessToken | Should -Not -BeNullOrEmpty
    }
}