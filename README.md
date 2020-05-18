# SysAid-PowerShell-API
Scripts to complete common bulk tasks easily using PowerShell via SysAid REST API 

https://community.sysaid.com/Sysforums/posts/list/13563.page


Quick Use

# Authenticate to Capture JSESSIONID

Import-Module .\SysAid_Authentication.ps1

Get-SysAidToken -Username "admin" -Password "Password1" -SysAidURL "https://sysaid.example.com"

# Mass Change Categories on SysAid Tickets

Import-Module .\SysAid_Mass_Categories_Change.ps1

Amend-SysAidTicketsCategories -File "C:\Users\username\Desktop\SysAidIDs.csv" -JSESSIONID "YourJSESSIONIDForSysAID" -SysAidURL "https://sysaid.example.com"

# Mass Close SysAid Tickets 

Import-Module .\SysAid_Mass_Close.ps1

Close-SysAidTickets -File "C:\Users\username\Desktop\SysAidIDs.csv" -JSESSIONID "YourJSESSIONIDForSysAID" -SysAidURL "https://sysaid.example.com"
