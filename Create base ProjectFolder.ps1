$FolderStructure = Get-Content ".\Functions\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json

New-Item -Path "$($FolderStructure.BaseProjectFolder)\Folder01" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$($FolderStructure.BaseProjectFolder)\Folder02" -ItemType Directory -ErrorAction SilentlyContinue

$FolderStructure.BaseFolders | ForEach-Object {
  New-Item -Path "$($FolderStructure.BaseProjectFolder)\Folder01\$_" -ItemType Directory
}
