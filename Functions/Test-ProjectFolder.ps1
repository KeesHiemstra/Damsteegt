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
                Write-Verbose -Message "'$ProjectFolderPath\$_' doesn't exist"
                Write-Output $false
                break
            }
        }

        # Check plain files
        $FolderStructure.Files | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                Write-Output $false
                break
            }
        }

        # Check complex files
        $FolderStructure.dotx | ForEach-Object {
            if ( -not (Test-Path -Path "$ProjectFolderPath\$($_.Target)\$($_.Name)") )
            {
                Write-Verbose -Message "'$ProjectFolderPath\$_' file doesn't exist"
                Write-Output $false
                break
            }
        }

        Write-Output $true
    }
    End
    {
    }
}
