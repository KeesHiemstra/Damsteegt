# Report the new project folders as mail.
#
# Version 1.11 (2019-03-18, Kees Hiemstra)
# - Exclude older folders from the report.
# Version 1.10 (2019-03-14, Kees Hiemstra)
# - Updated the ProjectFolderStructure.json with more Base project folders.
# Version 1.00 (2019-03-11, Kees Hiemstra)
# - Initial version.

Add-Content -Path "C:\Etc\Log\ProjectFolders.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Started report"
$PreviousFolders = Import-Csv -Path "C:\Etc\ProjectFolders\PreviousFolders.csv" -Delimiter "`t"

$DateCheck = (Get-Date).AddDays(-5)

# Prepare the folder-array
$CheckFolders = (Get-Content ".\Modules\ProjectFolders\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json)
$BaseProjectFolders = @{}
$CheckFolders.BaseProjectFolders.psobject.Properties | ForEach-Object { $BaseProjectFolders[$_.Name] = $_.Value }

$Folders = @()

$BaseProjectFolders.Keys | 
    ForEach-Object {
        $ProjectBaseFolder = $_
        $BaseProjectFolder = ($BaseProjectFolders.$_)

        $Folders += Get-ChildItem -Path $BaseProjectFolder |
            Where-Object { $_.Attributes -eq 'Directory' } |
            Sort-Object -Property CreationTime -Descending |
            Where-Object { $_.CreationTime -ge $DateCheck } |
            Select-Object -Property @{n='Base'; e={$ProjectBaseFolder}}, Name, CreationTime
        }

$NewFolders = Compare-Object -ReferenceObject $PreviousFolders -DifferenceObject $Folders -Property Base, Name -PassThru |
    Where-Object -FilterScript { $_.SideIndicator -eq '=>' } |
    Select-Object -Property Base, Name, CreationTime, SideIndicator

if ($NewFolders.Count -gt 0) {
    $NewFolders |
        Send-ObjectAsHTMLTableMessage -Subject "Nieuwe project folders" -SmtpServer "damsteegtwaterwerken.nl" -From "khiemstra@damsteegtwaterwerken.nl" -MessageType Report -To "khiemstra@damsteegtwaterwerken.nl"
}

$Folders | 
    Export-csv -Path "C:\Etc\ProjectFolders\PreviousFolders.csv" -NoTypeInformation -Delimiter "`t"
