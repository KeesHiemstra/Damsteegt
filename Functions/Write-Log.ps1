param 
(
    [string]
    $Message
)

Add-Content -Path "C:\Etc\Log\System.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $Message"
