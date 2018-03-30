$SalesforceCommerceCloudEnvironments = [PSCustomObject]@{
    Name = "Production"
    RootURL = "production-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3625
    BusinessManagerUserPasswordstateEntryID = 3774
},
[PSCustomObject]@{
    Name = "Staging"
    RootURL = "staging-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3624
    BusinessManagerUserPasswordstateEntryID = 3770
},
[PSCustomObject]@{
    Name = "Development"
    RootURL = "development-tt001-tervis.demandware.net"
    APIClientPasswordstateEntryID = 3624
    BusinessManagerUserPasswordstateEntryID = 3771
}

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

function Set-TervisSCCAPIBusinessManagerUserCredential {
    param (
        [Parameter(Mandatory)]$EnvironmentName
    )
    $Credential = $SalesforceCommerceCloudEnvironments |
    Where-Object Name -EQ $EnvironmentName |
    Select-Object -ExpandProperty BusinessManagerUserPasswordstateEntryID |
    % { 
        Get-PasswordstateCredential -PasswordID $_ 
    }

    Set-SCCAPIBusinessManagerUserCredential -Credential $Credential 
}

function Set-TervisSCCAPIEnvironment {
    param (
        [Parameter(Mandatory)]$EnvironmentName
    )
    Set-TervisSCCAPIRootURL -EnvironmentName $EnvironmentName
    Set-TervisSCCAPIClientCredential -EnvironmentName $EnvironmentName
    Set-TervisSCCAPIBusinessManagerUserCredential -EnvironmentName $EnvironmentName
}

Set-TervisSCCAPIEnvironment -EnvironmentName Development

function Get-TervisSCCCustomerSearchResult {
    param (
        [String]$email
    )
    Get-SCCDataCustomerSearchResult @PSBoundParameters -customer_list_id Tervis
}

function Get-TervisSCCCustomer {
    param (
        $Email
    )
    $SearchResult = Get-TervisSCCCustomerSearchResult -email $Email
    $DataCustomer = Get-SCCDataCustomerListCustomer -customer_no $SearchResult.hits.data.customer_no -list_id Tervis
    Get-SCCShopCustomer -customer_id $DataCustomer.customer_id -SiteName Tervis -expand addresses
}