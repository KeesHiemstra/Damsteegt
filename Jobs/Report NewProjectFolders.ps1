# Report the new project folders as mail.
#
# Version 1.00 (2019-03-11, Kees Hiemstra)
# - Initial version.

Add-Content -Path "C:\Etc\Log\ProjectFolders.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Started report"
$PreviousFolders = Import-Csv -Path "C:\Etc\ProjectFolders\PreviousFolders.csv" -Delimiter "`t"

$CheckDate = (Get-Date).AddDays(-5)
$Folders = Get-ChildItem -Path "\\NASServer\Projecten\ALG" -Directory | 
    Select-Object -Property Name, CreationTime |
    Where-Object { $_.CreationTime -ge $CheckDate} |
    Sort-Object -Property CreationTime

$NewFolders = Compare-Object -ReferenceObject $PreviousFolders -DifferenceObject $Folders -PassThru |
    Select-Object -Property Name, CreationTime 

if ($NewFolders.Count -gt 0) {
    $NewFolders |
        Send-ObjectAsHTMLTableMessage -Subject "Nieuwe project folders" -SmtpServer "damsteegtwaterwerken.nl" -From "khiemstra@damsteegtwaterwerken.nl" -MessageType Report -To "khiemstra@damsteegtwaterwerken.nl"
}

$Folders | 
    Export-csv -Path "C:\Etc\ProjectFolders\PreviousFolders.csv" -NoTypeInformation -Delimiter "`t"

