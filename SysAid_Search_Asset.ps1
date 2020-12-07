

##EXAMPLE

# 


Function Get-SysAidAsset {
    Param(
    [parameter(Mandatory=$true)]
    [String]$File,
    [Parameter(Mandatory=$true)]
    [string]$JSESSIONID,
    [Parameter(Mandatory=$true)]
    [string]$SysAidURL

    )

#Put URL Validation Here


#Import Asset IDs from CSV with a Header of #

Write-Verbose -Message "Importing $ImportFile" -Verbose

$SysAidAssetImport = Import-Csv -Path $File

#Count SysAid ID's and get Approval spitting first and last ID out for validation

$SysAidAssetImportCount = $SysAidAssetImport.AssetID.Count

Write-Verbose -Message "There is $SysAidAssetImportCount ID's Imported" -Verbose



#Put Code Here to Capture Sysaid Credentials

#Put Code Here to Validate Login 

$results = @()


foreach ($Asset in $SysAidAssetImport) {

$SysaidAsset = $Asset.AssetID

Write-Verbose $SysaidAsset -Verbose

[System.Uri]$Uri  = "$SysAidURL/api/v1/asset/search?query=$SysaidAsset&fields=last_access"

$ContentType = "application/json" # Add the content type
$Method = 'GET' # Add the method type



$Cookie = New-Object System.Net.Cookie
$Cookie.Name = "JSESSIONID" # Add the name of the cookie
$Cookie.Value = $JSESSIONID # Add the value of the cookie
$Cookie.Domain = $uri.DnsSafeHost

$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$WebSession.Cookies.Add($Cookie)


# Splat the parameters
$props = @{
    Uri         = $Uri.AbsoluteUri
    ContentType = $ContentType
    Method      = $Method
    WebSession  = $WebSession
#    Body        = $Body
}

#Write-Verbose -Message "Attempting to find $SysaidAsset Asset" -Verbose

$Search = Invoke-RestMethod @props


#New Object

$result = New-Object -TypeName psobject 



if ($Search -ne $null) {

Write-Verbose -Message "Successfully found $SysaidAsset Asset" -Verbose


#Splat infomation what we want.

$AssetInfoID = $Search.Name


$AssetInfoLastAccess = $Search.info | Select key, valueCaption | where key -eq last_access 


$result | Add-Member -MemberType NoteProperty -Name AssetID -Value $AssetInfoID
$result | Add-Member -MemberType NoteProperty -Name AssetLastAccessDate -Value $AssetInfoLastAccess.valueCaption

Clear-Variable Search

}

$results += $result


}

$results

}
