# Save a Json with the folders and files
# 2019-03-04

Remove-Variable EmptyProjectFolder -ErrorAction SilentlyContinue
$EmptyProjectFolder = New-Object -TypeName psobject
Add-Member -InputObject $EmptyProjectFolder -NotePropertyName 'BaseProjectFolder' -NotePropertyValue @{'Alg' = '\\NASServer\Projecten\Alg'; 'CS' = '\\NASServer\Projecten\CS'}
Add-Member -InputObject $EmptyProjectFolder -NotePropertyName 'Folders' -NotePropertyValue (Get-ChildItem EmptyProjectFolder -Recurse -Directory).FullName.Replace("C:\Etc\ProjectFolders\EmptyProjectFolders\",'')
Add-Member -InputObject $EmptyProjectFolder -NotePropertyName 'Files' -NotePropertyValue (Get-ChildItem EmptyProjectFolder -Recurse -File).FullName.Replace("C:\Etc\ProjectFolders\EmptyProjectFolders\",'')

$EmptyProjectFolder | ConvertTo-Json | Out-File -FilePath "C:\Users\Kees Hiemstra\Documents\ProjectFolderStructure.json"
