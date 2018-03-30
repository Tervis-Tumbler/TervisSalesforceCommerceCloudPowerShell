$SalesforceCommerceCloudEnvironments = [PSCustomObject]@{
    Name = "Production"
    RootURL = "production-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3625
},
[PSCustomObject]@{
    Name = "Staging"
    RootURL = "staging-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3624
},
[PSCustomObject]@{
    Name = "Development"
    RootURL = "development-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3624
}

#$CustomizerSCCCredential = Get-PasswordstateCredential -PasswordID 3625
Set-SCCAPIRootURL -SCCAPIRoot "production-tt001-tervis.demandware.net"

function Set-TervisSCCAPIRootURL {
    param (
        [Parameter(Mandatory)]$EnvironmentName
    )
    $URL = $SalesforceCommerceCloudEnvironments |
    Where-Object Name -EQ $EnvironmentName |
    Select-Object -ExpandProperty RootURL

    Set-SCCAPIRootURL -SCCAPIRoot $URL
}

function Set-TervisSCCAPIClientCredential {
    param (
        [Parameter(Mandatory)]$EnvironmentName
    )
    $Credential = $SalesforceCommerceCloudEnvironments |
    Where-Object Name -EQ $EnvironmentName |
    Select-Object -ExpandProperty APIClientPasswordstateEntryID |
    % { 
        Get-PasswordstateCredential -PasswordID $_ 
    }

    Set-SCCAPIClientCredential -Credential $Credential  
}

function Set-TervisSCCAPIEnvironment {
    param (
        [Parameter(Mandatory)]$EnvironmentName
    )
    Set-TervisSCCAPIRootURL -EnvironmentName $EnvironmentName
    Set-TervisSCCAPIClientCredential -EnvironmentName $EnvironmentName
}

Set-TervisSCCAPIEnvironment -EnvironmentName Development

function Get-TervisSCCCustomerSearchResult {
    param (
        [String]$email
    )
    Get-SCCCustomerSearchResult @PSBoundParameters -customer_list_id Tervis
}

function Get-TervisSCCCustomer {
    param (
        $Email
    )
    $Result = Get-TervisSCCCustomerSearchResult -email $Email
    Get-SCCCustomer -customer_id $Result.hits.data.customer_no
}