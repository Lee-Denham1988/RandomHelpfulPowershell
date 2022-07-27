$url = "https://api.macvendors.com/v1/lookup/"
#$macaddr = Read-Host "Enter macaddress: " # To allow reading from console to input single MAC.
$macaddr = Import-Csv C:\temp\macaddrs.csv  #To allow importing CSV with MACs in the macaddress column.
#$token = "" #Insert API token.
$header = @{
    Authorization="Bearer $token"
}

 $header | ConvertTo-Json
ForEach ($mac in $macaddr) {    
    $uri = $url + [System.Web.HTTPUtility]::UrlEncode($mac.macaddress)

    $vendor = Invoke-RestMethod -Method Get -URI $uri -Headers $header
    $output = $mac.MACAddress + " " + $vendor.data.organization_name
    $output
    Start-Sleep(1)

}