#########################IMPORTANT INFORMATION#########################

####THIS SCRIPT CAN EASILY CAUSE MASS CHANGES ON SYSAID USE WISELY####


##EXAMPLE

# Amend-SysAidTicketsCategories -File "C:\Users\username\Desktop\SysAidIDs.csv" -JSESSIONID "YourJSESSIONIDForSysAID" -SysAidURL "https://sysaid.example.com"


Function Amend-SysAidTicketsCategories {
    Param(
    [parameter(Mandatory=$true)]
    [String]$File,
    [Parameter(Mandatory=$true)]
    [string]$JSESSIONID,
    [Parameter(Mandatory=$true)]
    [string]$SysAidURL
    )

#Put URL Validation Here


#Import SysAid IDs from CSV with a Headers of #, 

Write-Verbose -Message "Importing $ImportFile" -Verbose

$SysAidIDImport = Import-Csv -Path $File -Header "#","1st Level Category","2nd Level Category","3rd Level Category"

#Count SysAid ID's and get Approval spitting first and last ID out for validation

$SysAidIDImportCount = $SysAidIDImport.'#'.Count

Write-Verbose -Message "There is $SysAidIDImportCount ID's Imported" -Verbose



#Put Code Here to Capture Sysaid Credentials

#Put Code Here to Validate Login 


foreach ($ID in $SysAidIDImport) {

$SysaidID = $ID.'#'
$SysAidFirstCat = $ID.'1st Level Category'
$SysAidSecondCat = $ID.'2nd Level Category'
$SysAidThirdCat = $ID.'3rd Level Category'


[System.Uri]$Uri  = "$SysAidURL/api/v1/sr/$SysaidID"

$ContentType = "application/json" # Add the content type
$Method = 'PUT' # Add the method type

$SysAidCategories = $SysAidFirstCat + "_" + $SysAidSecondCat +  "_" + $SysAidThirdCat

$Body = @"

{

"id":"$SysaidID",

"info":

[{"key":"problem_type", "value":"$SysAidCategories"}
]}


"@ # Add the body for the request



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
    Body        = $Body
}

Write-Verbose -Message "Adjusting $SysaidID Categories to $SysAidFirstCat | $SysAidSecondCat | $SysAidThirdCat" -Verbose

Invoke-RestMethod @props



}

}
