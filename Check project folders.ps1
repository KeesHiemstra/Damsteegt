# Check which folders need extra folders or documents
# Version 1.00 (2019-03-01, Kees Hiemstra)

$CheckFolder = "G:\Alg"
$DateCheck = (Get-Date).AddDays(-2)

# Filter list on only directories from the last week
#$FolderList = 
Get-ChildItem -Path $CheckFolder | 
    Where-Object { $_.Attributes -eq 'Directory' } |
    Sort-Object -Property CreationTime -Descending |
    Where-Object { $_.CreationTime -ge $DateCheck } |
    ForEach-Object { 
        Test-ProjectFolder $_.Name 
    } | 
    Where-Object { $_.BaseFolders } |
    Format-Table


break
$CheckFolder = "G:\Alg"
$DateCheck = (Get-Date).AddMonths(-1)

# Filter list on only directories from the last month
$FolderList = Get-ChildItem -Path $CheckFolder | 
    Where-Object { $_.Attributes -eq 'Directory' } |
    Sort-Object -Property CreationTime -Descending |
    Where-Object { $_.CreationTime -ge $DateCheck } |
    ForEach-Object { Test-ProjectFolder $_.Name } |
    ConvertTo-Csv -Delimiter "`t" -NoTypeInformation | Clip

#foreach ($Folder in $FolderList)
#{
#    Test-ProjectFolder -ProjectFolderName $Folder.Name 
#    #$Folder.Name
#}

#Write-Host "Number of folders: $($FolderList.Length)"