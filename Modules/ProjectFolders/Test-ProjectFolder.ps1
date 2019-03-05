<#
.Synopsis
    Test if the project complete.
.Description
.Example
    Test-ProjectFolder [-ProjectFolderName] "AD19.9876 New project test"
    
.Notes
    Version 1.00 (2019-03-04, Kees Hiemstra)
    - Initial version.
#>
function Test-ProjectFolder
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
        $Result = New-Object -TypeName psobject
        Add-Member -InputObject $Result -NotePropertyName 'FolderName' -NotePropertyValue $ProjectFolderName
        Add-Member -InputObject $Result -NotePropertyName 'BaseFolders' -NotePropertyValue $true
        Add-Member -InputObject $Result -NotePropertyName 'Folders' -NotePropertyValue $false
        Add-Member -InputObject $Result -NotePropertyName 'Files' -NotePropertyValue $false
        Add-Member -InputObject $Result -NotePropertyName 'dotx' -NotePropertyValue $false

        $FolderStructure = Get-Content ".\Modules\ProjectFolders\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json
        $ProjectFolderPath = "$($FolderStructure.BaseProjectFolder)\$ProjectFolderName"

        Write-Verbose -Message "ProjectFolderPath: '$ProjectFolderName'"
        
        # Check BaseProjectFolder
        if ( -not (Test-Path -Path $ProjectFolderPath) )
        {
            Write-Error -Message "'$ProjectFolderPath' does not exists."
            Write-Output $false
            return
        }

        # Check base project folders
        $FolderStructure.BaseFolders | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$_") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' doesn't exist"
                $Result.BaseFolders = $Result.BaseFolders -and $false
            }
        }
        
        # Check subfolders
        $FolderStructure.Folders | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$_") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' doesn't exist"
                $Result.Folders = $false
            }
        }

        # Check plain files
        $FolderStructure.Files | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                $Result.Files = $false
            }
        }

        # Check complex files
        $FolderStructure.dotx | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                $Result.dotx = $false
            }
        }
        Write-Verbose -Message $Result

        Write-Output $Result
    }
    End
    {
    }
}
