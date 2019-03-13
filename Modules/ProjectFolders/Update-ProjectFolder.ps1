<#
.Synopsis
    Complete the project folder.
.Description
    Make subfolders for the project folder and copy the initial documents.
    Exitsting initial document are not overwritten.
.Example
    Update-ProjectFolder [-ProjectFolderName] "AD19.9876 New project test"

    
.Notes
    Version 1.20 (2019-03-13, Kees Hiemstra)
    - Added ProjectFolderName parameter.
    Version 1.10 (2019-03-07, Kees Hiemstra)
    - Added check through Test-ProjectFolder, it will skip the update is .BaseFolders -eq $false
    Version 1.00 (2019-03-04, Kees Hiemstra)
    - Initial version.
#>
function Update-ProjectFolder
{
    [CmdletBinding(PositionalBinding=$true)]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Position=0)]
        [string]
        $ProjectFolderName,

        [Parameter(Mandatory=$false,
                   Position=1)]
        [ValidateSet('Alg', 'CS')]
        [Alias('Base')]
        [string]
        $ProjectBaseFolder = 'Alg'
    )

    Begin
    {
    }
    Process
    {
        $FolderStructure = Get-Content ".\Modules\ProjectFolders\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json
        Write-Verbose -Message "BaseProjectFolder: $($FolderStructure.BaseProjectFolders.($ProjectBaseFolder))"

        $ProjectFolderPath = "$($FolderStructure.BaseProjectFolders.($ProjectBaseFolder))\$ProjectFolderName"
        
        if ( -not (Test-Path -Path $ProjectFolderPath) )
        {
            Write-Error -Message "'$ProjectFolderPath' does not exists."
            Write-Output $false
            return
        }

        if ( -not (Test-ProjectFolder -ProjectFolderName $ProjectFolderName).BaseFolders )
        {
            Write-Error -Message "Base folders are not correct"
            break
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
