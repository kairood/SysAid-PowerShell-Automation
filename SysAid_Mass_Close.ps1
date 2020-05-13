#########################IMPORTANT INFORMATION#########################

####THIS SCRIPT CAN EASILY CAUSE MASS CLOSURE ON SYSAID USE WISELY####


##EXAMPLE

# Close-SysAidTickets -File "C:\Users\username\Desktop\SysAidIDs.csv" -JSESSIONID "YourJSESSIONIDForSysAID" -SysAidURL "https://sysaid.example.com"


Function Close-SysAidTickets {
    Param(
    [parameter(Mandatory=$true)]
    [String]$File,
    [Parameter(Mandatory=$true)]
    [string]$JSESSIONID,
    [Parameter(Mandatory=$true)]
    [string]$SysAidURL,
    [Parameter(Mandatory=$true)]
    [string]$CloseMessage

    )

#Put URL Validation Here


#Import SysAid IDs from CSV with a Header of #

Write-Verbose -Message "Importing $ImportFile" -Verbose

$SysAidIDImport = Import-Csv -Path $File -Header "#","Solution"

#Count SysAid ID's and get Approval spitting first and last ID out for validation

$SysAidIDImportCount = $SysAidIDImport.'#'.Count

Write-Verbose -Message "There is $SysAidIDImportCount ID's Imported" -Verbose



#Put Code Here to Capture Sysaid Credentials

#Put Code Here to Validate Login 


foreach ($ID in $SysAidIDImport) {

$SysaidID = $ID.'#'
$SysAidSolution = $ID.'Solution'
[System.Uri]$Uri  = "$SysAidURL/api/v1/sr/$SysaidID/close"

$ContentType = "application/json" # Add the content type
$Method = 'PUT' # Add the method type
$Body = @"

{
	"solution": "$SysAidSolution"
}

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

Write-Verbose -Message "Closing $SysaidID Request with solution $CloseMessage" -Verbose

Invoke-RestMethod @props



}

}
