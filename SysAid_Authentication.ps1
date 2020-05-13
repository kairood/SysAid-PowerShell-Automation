
##EXAMPLE

# Get-SysAidToken -Username "admin" -Password "Password1" -SysAidURL "https://sysaid.example.com"

Function Get-SysAidToken {
    Param(
    [parameter(Mandatory=$true)]
    [String]$Username,
    [Parameter(Mandatory=$true)]
    [String]$Password,
    [Parameter(Mandatory=$true)]
    [string]$SysAidURL

    )


[System.Uri]$Uri  = "$SysAidURL/api/v1/login"

$ContentType = "application/json" # Add the content type
$Method = 'POST' # Add the method type
$Body = @"

{
	"user_name": "$Username",
	"password": "$Password"
}

"@ # Add the body for the request


$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession



# Splat the parameters
$props = @{
    Uri         = $Uri.AbsoluteUri
    ContentType = $ContentType
    Method      = $Method
    WebSession  = $WebSession
    Body        = $Body
}

Try {

$WebRequest = Invoke-WebRequest @props -ErrorAction Stop 

#Capture Status
$StatusCode = $WebRequest.StatusCode
}

Catch {

$StatusCode = $_.Exception.Response.StatusCode.value__

}

if ($StatusCode -eq "200") {

Write-Verbose "The Web Request Was Successful, Capturing JSESSIONID Cookie..." -Verbose

#Capture JSESSIONID Cookie
$cookies = $WebSession.Cookies.GetCookies($Uri) 


Write-Verbose "$cookies" -Verbose


}

elseif ($StatusCode -eq "401") {


Write-Verbose "The Web Request Failed, with status code $StatusCode. Please enter the correct login information." -Verbose


}

elseif ($StatusCode -ne "200" -or "401") {


Write-Verbose "The Web Request Failed, with status code $StatusCode. Please verify the entered parameters." -Verbose


}
}
