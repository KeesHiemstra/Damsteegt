# Save a Json with the folders and files
# 2019-03-04

Remove-Variable EmptyProjectFolder -ErrorAction SilentlyContinue
$EmptyProjectFolder = New-Object -TypeName psobject
Add-Member -InputObject $EmptyProjectFolder -NotePropertyName 'Folders' -NotePropertyValue (Get-ChildItem EmptyProjectFolder -Recurse -Directory).FullName.Replace('C:\Users\Kees Hiemstra\Dev\EmptyProjectFolder\','')
Add-Member -InputObject $EmptyProjectFolder -NotePropertyName 'Files' -NotePropertyValue (Get-ChildItem EmptyProjectFolder -Recurse -File).FullName.Replace('C:\Users\Kees Hiemstra\Dev\EmptyProjectFolder\','')

$EmptyProjectFolder | ConvertTo-Json | Out-File -FilePath "C:\Users\Kees Hiemstra\Dev\Functions\ProjectFolderStructure.json"
