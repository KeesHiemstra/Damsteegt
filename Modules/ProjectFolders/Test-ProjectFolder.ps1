<#
.Synopsis
    Test if the project complete.
.Description
.Example
    Test-ProjectFolder [-ProjectFolderName] "AD19.9876 New project test"
    
.Notes
    Version 1.01 (2019-03-05, Kees Hiemstra)
    - Bug fix.
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
        [string]
        $ProjectFolderName
    )

    Begin
    {
    }
    Process
    {
        $Result = New-Object -TypeName psobject
        Add-Member -InputObject $Result -NotePropertyName 'ProjectFolderName' -NotePropertyValue $ProjectFolderName
        Add-Member -InputObject $Result -NotePropertyName 'BaseFolders' -NotePropertyValue $false
        Add-Member -InputObject $Result -NotePropertyName 'Folders' -NotePropertyValue $false
        Add-Member -InputObject $Result -NotePropertyName 'Files' -NotePropertyValue $false
        Add-Member -InputObject $Result -NotePropertyName 'dotx' -NotePropertyValue $false

        $FolderStructure = Get-Content ".\Modules\ProjectFolders\ProjectFolderStructure.json" | Out-String | ConvertFrom-Json
        Write-Verbose -Message "BaseProjectFolder: $($FolderStructure.BaseProjectFolder)"

        $ProjectFolderPath = "$($FolderStructure.BaseProjectFolder)\$ProjectFolderName"

        Write-Verbose -Message "ProjectFolderPath: '$ProjectFolderName'"
        
        # Check BaseProjectFolder
        if ( -not (Test-Path -Path $ProjectFolderPath) )
        {
            Write-Error -Message "'$ProjectFolderPath' does not exists."
            Write-Output $Result
            return
        }

        #region Base project folders
        $Check = $true
        $FolderStructure.BaseFolders | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$_") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' doesn't exist"
                $Check = $false
            }
            else
            {
                $Check = $Check -and $true
            }
        }
        $Result.BaseFolders = $Check
        Write-Verbose "Base folders: $($Result.BaseFolders)"
        #endregion

        #region Subfolders
        $Check = $true
        $FolderStructure.Folders | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$_") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' doesn't exist"
                $Check = $false
            }
        }
        $Result.Folders = $Check
        #endregion

        #region Plain files
        $Check = $true
        $FolderStructure.Files | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                $Check = $false
            }
        }
        $Result.Files = $Check
        #endregion

        #region Complex files
        $Check = $true
        $FolderStructure.dotx | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                $Check = $false
            }
        }
        $Result.dotx = $Check
        #endregion

        Write-Verbose -Message $Result

        Write-Output $Result
    }
    End
    {
    }
}
