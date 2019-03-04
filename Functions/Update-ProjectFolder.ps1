<#
.Synopsis
    Complete the project folder.
.Description
    Make subfolders for the project folder and copy the initial documents.
    Exitsting initial document are not overwritten.
.Example
    Update-ProjectFolder [-ProjectFolderName] "AD19.9876 New project test"

    
.Notes
    Version 1.00 (2019-03-04, Kees Hiemstra)
    - Initial version.
#>
function Update-ProjectFolder
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ProjectFolderName
    )

    Begin
    {
    }
    Process
    {
        $FolderStructure = Get-Content ".\Functions\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json
        $ProjectFolderPath = "$($FolderStructure.BaseProjectFolder)\$ProjectFolderName"
        
        if ( -not (Test-Path -Path $ProjectFolderPath) )
        {
            Write-Error -Message "'$ProjectFolderPath' does not exists."
            Write-Output $false
            return
        }

        # Check subfolders
        $FolderStructure.Folders | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$_") )
            {
                New-Item -Path "$ProjectFolderPath\$_" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
                Write-Verbose "Folder '$ProjectFolderPath\$_' created"
            }
        }

        # Check plain files
        $FolderStructure.Files | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                $FileToCopy = Get-ChildItem -Path "$($_.Source)\$($_.Name)" | Sort-Object -Descending | Select-Object -First 1
                Copy-Item -Path $FileToCopy -Destination "$ProjectFolderPath\$($_.Target)"
                Write-Verbose "Copied '$FileToCopy' to '$ProjectFolderPath\$($_.Target)' "
            }
        }

        # Check dotx files
        $FolderStructure.dotx | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                $FileToCopy = Get-ChildItem -Path "$($_.Source)\$($_.Name)" | Sort-Object -Descending | Select-Object -First 1
                $FileName = $FileToCopy.Name.Replace($FileToCopy.Extension, "$($_.Extension)")
                Copy-Item -Path $FileToCopy -Destination "$ProjectFolderPath\$($_.Target)\$FileName"
                Write-Verbose "Copied '$FileToCopy' to '$ProjectFolderPath\$($_.Target)\$FileName' "
            }
        }
    }
    End
    {
    }
}
