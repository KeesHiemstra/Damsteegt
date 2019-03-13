#
# Filter list on only directories from the last week
#
# Version 1.01 (2019-03-08, Kees Hiemstra)
# - Added logging (C:\Etc\ProjectFolders\ProjectFolders.log)
# Version 1.00 (2019-03-07, Kees Hiemstra)
# - Initial version.

Add-Content -Path "C:\Etc\Log\ProjectFolders.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Started update"
$CheckFolder = (Get-Content ".\Modules\ProjectFolders\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json).BaseProjectFolders

$DateCheck = (Get-Date).AddDays(-2)

Get-ChildItem -Path $CheckFolder | 
    Where-Object { $_.Attributes -eq 'Directory' } |
    Sort-Object -Property CreationTime -Descending |
    Where-Object { $_.CreationTime -ge $DateCheck } |
    ForEach-Object { 
        Test-ProjectFolder $_.Name
    } | 
    Where-Object { $_.BaseFolders -and -not ($_.Folders -and $_.Files -and $_.dotx) } |
    Update-ProjectFolder
